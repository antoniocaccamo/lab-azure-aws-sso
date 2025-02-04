import logging
import azure.functions as func
import botocore
import requests 
import msal
import os
import boto3

mi_client_id=os.getenv('USER_MANAGED_IDENTITY_CLIENT_ID') # "da348ffe-d5e8-4f4e-8f19-412f9adb33eb" 
audience=os.getenv('AUDIENCE')                            # "api://7b917162-75b1-48f3-94c2-7ff5d1f95fe8"
aws_role_arn=os.getenv('AWS_ROLE_ARN')
aws_s3_bucket=os.getenv('AWS_S3_BUCKET')
aws_role_session_name="azure-aws"

app = func.FunctionApp()


@app.route(route="http_trigger", auth_level=func.AuthLevel.FUNCTION)
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )

@app.timer_trigger(
        schedule="0 * 1/5 * * *", 
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
        blobs = s3client.getObjectAllOfBucket(aws_s3_bucket)
        for b in blobs:
            logging.info(f" blob: [{b}]")

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




@app.event_grid_trigger(arg_name="azeventgrid")
def EventGridTrigger(azeventgrid: func.EventGridEvent):
    logging.info('Python EventGrid trigger processed an event')
