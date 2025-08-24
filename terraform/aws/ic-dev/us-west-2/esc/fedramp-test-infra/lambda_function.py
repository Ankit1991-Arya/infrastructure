import boto3
import os

def handler(event, context):
    s3 = boto3.client('s3')
    source_bucket = os.environ['SOURCE_BUCKET']
    backup_bucket = os.environ['BACKUP_BUCKET']

    # List objects in the source bucket
    objects = s3.list_objects_v2(Bucket=source_bucket)

    if 'Contents' in objects:
        for obj in objects['Contents']:
            copy_source = {'Bucket': source_bucket, 'Key': obj['Key']}
            s3.copy_object(CopySource=copy_source, Bucket=backup_bucket, Key=obj['Key'])

    return {
        'statusCode': 200,
        'body': 'Backup completed successfully'
    }