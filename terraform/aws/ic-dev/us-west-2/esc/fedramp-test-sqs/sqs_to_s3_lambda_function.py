import boto3
import os
import json
import logging
from datetime import datetime

# Initialize the S3 and SQS clients
s3_client = boto3.client('s3')
sqs_client = boto3.client('sqs')

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    queue_url = os.environ['SQS_QUEUE_URL']
    backup_bucket = os.environ['BACKUP_BUCKET']
    
    try:
        # Receive messages from the SQS queue
        response = sqs_client.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=10
        )
        
        if 'Messages' in response:
            for message in response['Messages']:
                # Process the message
                message_body = message['Body']
                receipt_handle = message['ReceiptHandle']
                
                # Generate a unique S3 object key based on the current time
                timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H-%M-%SZ')
                s3_key = f"backup/{timestamp}.json"
                
                # Store the message in the S3 bucket
                s3_client.put_object(
                    Bucket=backup_bucket,
                    Key=s3_key,
                    Body=message_body
                )
                
                logger.info(f"Stored message in S3 bucket {backup_bucket} with key {s3_key}")
        else:
            logger.info(f"No messages found in SQS queue {queue_url}")
            
    except Exception as e:
        logger.error(f"Error processing SQS messages: {str(e)}")
        raise e