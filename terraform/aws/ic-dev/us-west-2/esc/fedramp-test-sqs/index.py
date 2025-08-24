import json
import os
import boto3

sqs = boto3.client('sqs')

def lambda_handler(event, context):
    queue_url = os.environ['SQS_QUEUE_URL']
    message_body = json.dumps({ 'message': 'Hello SQS' })

    try:
        response = sqs.send_message(
            QueueUrl=queue_url,
            MessageBody=message_body
        )
        print('Message sent successfully')
    except Exception as e:
        print(f'Error sending message: {e}')