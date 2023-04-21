import json
import os
import logging
import boto3

from base64 import b64decode
logger = logging.getLogger()
logger.setLevel(logging.INFO)

ENCRYPTED_FOO2 = os.environ['FOO2']
FOO2 = boto3.client('kms').decrypt(CiphertextBlob=b64decode(ENCRYPTED_FOO2))['Plaintext'].decode('utf-8')

def handler(event, context):
    print("event: ", event)
    print("context: ", context)
    print("successful")
    logger.info(f'Foo {FOO2} is output variable')
    return {
        'statusCode': 200,
        'body': json.dumps('successful')
    }