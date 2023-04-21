import json

def handler(event, context):
    print("event: ", event)
    print("context: ", context)
    print("successful")
    return {
        'statusCode': 200,
        'body': json.dumps('successful')
    }