import json
import os
import logging

def handler(event, context):
    print("event: ", event)
    print("context: ", context)
    print("successful")
    test = os.environ['FOO2']
    logger.info('testing output variable', test)
    return {
        'statusCode': 200,
        'body': json.dumps('successful')
    }