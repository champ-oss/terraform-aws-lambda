import json
import os

def handler(event, context):
    print("event: ", event)
    print("context: ", context)
    print("successful")
    test = os.environ['FOO2']
    print(test)
    return {
        'statusCode': 200,
        'body': json.dumps('successful')
    }