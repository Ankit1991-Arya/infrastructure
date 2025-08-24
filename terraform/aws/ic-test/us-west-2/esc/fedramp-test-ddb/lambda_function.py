import boto3
import time
import json
import logging
from botocore.exceptions import ClientError

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.client('dynamodb')
kms = boto3.client('kms')

def lambda_handler(event, context):
    # Extract the table name and KMS key ARN from the event
    source_table = event['SourceTable']

    logger.info(f"Received event: {json.dumps(event)}")

    # Step 1: Create a backup of the existing DynamoDB table
    try:
        backup_response = dynamodb.create_backup(
            TableName=source_table,
            BackupName=f'{source_table}-backup'
        )
        backup_arn = backup_response['BackupDetails']['BackupArn']
        logger.info(f"Backup created successfully. ARN: {backup_arn}")
    except ClientError as e:
        logger.error(f"Error creating backup: {e}")
        raise

    return {
        'statusCode': 200,
        'body': json.dumps(f"Backup of {source_table} created successfully.")
    }