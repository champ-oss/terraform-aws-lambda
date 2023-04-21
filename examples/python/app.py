import json
import os
import logging
import boto3

from base64 import b64decode

test = boto3.client('kms').decrypt(
    CiphertextBlob=b64decode(ENCRYPTED),
    EncryptionContext={'terraform-aws-lambda-docker-hub': os.environ['FOO2']}
)['Plaintext'].decode('utf-8')

def handler(event, context):
    print("event: ", event)
    print("context: ", context)
    print("successful")
    logger.info('testing output variable', test)
    return {
        'statusCode': 200,
        'body': json.dumps('successful')
    }