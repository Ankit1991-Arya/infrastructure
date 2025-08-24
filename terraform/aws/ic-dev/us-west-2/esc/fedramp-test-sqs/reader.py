import json
import boto3
import base64
from botocore.exceptions import ClientError

sqs = boto3.client('sqs')
kms = boto3.client('kms')

def lambda_handler(event, context):
    for record in event['Records']:
        try:
            # Get the message body
            message_body = record['body']
            print(f"Received message: {message_body}")

        except Exception as e:
            print(f"Error processing message: {e}")