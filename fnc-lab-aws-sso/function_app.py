import logging
import azure.functions as func
import botocore
import requests 
import msal
import os
import boto3

mi_client_id=os.getenv('USER_MANAGED_IDENTITY_CLIENT_ID') 
audience=os.getenv('AUDIENCE')                           
aws_role_arn=os.getenv('AWS_ROLE_ARN')
aws_s3_bucket=os.getenv('AWS_S3_BUCKET')
aws_role_session_name="azure-aws"

app = func.FunctionApp()


@app.timer_trigger(
        schedule="0 */5 * * * *", 
        arg_name="myTimer", 
        run_on_startup=False,
        se_monitor=False
) 
def timer_trigger(myTimer: func.TimerRequest) -> None:
    if myTimer.past_due:
        logging.info('The timer is past due!')

    try:
        logging.info(f"mi_client_id: {mi_client_id}")
        mi = msal.UserAssignedManagedIdentity(client_id=mi_client_id)
        logging.info(f"mi          : {mi}")
        global_app = msal.ManagedIdentityClient(mi, http_client=requests.Session())
        logging.info(f"audience    : {audience}")
        result = global_app.acquire_token_for_client(resource=audience)
        logging.debug(f"result      : {result}")
        logging.debug(f"access_token: {result['access_token']}")
        
        logging.info("assuming role with web identity...")
        assumed_role=AssumeRoleWithWebIdentity(roleArn=aws_role_arn, roleSessionName=aws_role_arn, webIdentityToken=result['access_token'])
        
        s3client = S3Client(assumed_role.session)
        s3client.listOfBucktes()
        keys = s3client.getObjectAllOfBucket(aws_s3_bucket)
        for key in keys:
            logging.info(f"getting object: bucket [{aws_s3_bucket}] key: [{key}]")
            s3client.get_object(aws_s3_bucket, key)

        logging.info('Python timer trigger function executed.')

    except Exception as ex:
        logging.error(f"error occurred {ex}")
        raise ex
    

class AssumeRoleWithWebIdentity:
    _session: None

    def __init__(self, roleArn: str, roleSessionName: str, webIdentityToken:str) -> None:
        sts_client=boto3.client('sts')
        sts=sts_client.assume_role_with_web_identity(
            RoleArn=aws_role_arn,
            RoleSessionName=aws_role_session_name,
            WebIdentityToken=webIdentityToken
        )
        logging.info(f"assumed role => {sts['AssumedRoleUser']['Arn']}")
        self._session = boto3.session.Session(
            aws_access_key_id    =sts['Credentials']['AccessKeyId'],
            aws_secret_access_key=sts['Credentials']['SecretAccessKey'],
            aws_session_token    =sts['Credentials']['SessionToken']
        )
        
    @property
    def session(self) -> boto3.session.Session:
        return self._session


class S3Client:
    _client: None
    _resource: None

    def __init__(self, session: boto3.session.Session) -> None:
        self._client = session.client('s3')
        self._resource = session.resource('s3')

    def listOfBucktes(self):
        logging.info("list of bucktes:")
        idx = 1
        try:
            resp = self._client.list_buckets()
            for b in resp['Buckets']:
                logging.info(f"  [{idx}]: {b}")
                idx += 1
        except botocore.exceptions.BotoCoreError as error:
            logging.error(f"error occurred {error}")
            raise error

    def getObjectAllOfBucket(self, name: str) -> list :
        blobs: list[str] = []
        logging.info(f"content of bucket \"{name}\" :")
        bucket = self._resource.Bucket(name)
        for obj_sum in bucket.objects.all():
            obj = self._resource.Object(obj_sum.bucket_name, obj_sum.key)
            logging.info(f"  key [{obj.key}]  content_type [{obj.content_type}] content_length [{obj.content_length}]")
            if "directory"  not in obj.content_type:
                blobs.append(obj.key)
        return blobs
    
    def get_object(self, bucket_name:str, key: str) :
        res=self._client.get_object(Bucket=bucket_name, Key=key)
        try:
            response_code = res.get('ResponseMetadata', {}).get('HTTPStatusCode', None)
            if response_code == 200:
                body = res['Body']
                data = body.read()
                logging.info(f'File {bucket_name}/{key} downloaded: {data}')
                return data
            else:
                logging.error('Error while getting object {}. HTTP Response Code - {}'.format(key, response_code))
        except Exception as err:
            logging.error('Error while getting object {} - {}'.format(key, err))

        pass



