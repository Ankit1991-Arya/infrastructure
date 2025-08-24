/* eslint-disable no-plusplus */
/* eslint-disable no-console */
const { S3Client, ListObjectsV2Command, DeleteObjectCommand } = require('@aws-sdk/client-s3');

// Configure AWS SDK
const s3Client = new S3Client({ region: 'us-west-2' });
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand } = require('@aws-sdk/lib-dynamodb');

const client = new DynamoDBClient();
const ddbDocClient = DynamoDBDocumentClient.from(client);
// Define the S3 bucket and folders
const bucketName = 'uptime-datapoints';

const activeServices = async () => {
  try {
    const params = {
      TableName: 'service_registry_store',
      FilterExpression: '#is_active = :statusValue',
      ExpressionAttributeNames: {
        '#is_active': 'is_active',
      },
      ExpressionAttributeValues: {
        ':statusValue': 'TRUE',
      },
    };
    const data = await ddbDocClient.send(new ScanCommand(params));
    const activeServicesList = data.Items;
    console.log('activeServicesList', activeServicesList);
    return activeServicesList;
  } catch (error) {
    console.log('Could not retrieve active services');
  }
};

function getLast10DaysFromCurrentDate(date) {
  const result = [];
  const givenDate = new Date(date);

  for (let i = 0; i < 10; i++) {
    const newDate = new Date(givenDate);
    newDate.setDate(givenDate.getDate() - i);
    result.push(newDate.toISOString().split('T')[0]); // Format as YYYY-MM-DD
  }
  return result;
}

function constructKey(days) {
  const currentDate = new Date();
  const previousDate = new Date(currentDate);
  previousDate.setDate(currentDate.getDate() - days);
  return getLast10DaysFromCurrentDate(previousDate);
}

function getDayMonthYear(updatedDate) {
  const date = new Date(updatedDate);
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const year = date.getFullYear().toString();
  const day = date.getDate().toString().padStart(2, '0');
  return {
    year,
    month,
    day,
  };
}

// Function to get JSON files from S3
exports.handler = async () => {
  try {
    const services = await activeServices();
    for (const service of services) {
      const results = constructKey(90);
      for (const result of results) {
        const { year, month, day } = getDayMonthYear(result);
        const Prefix = `us-west-2/${service.service_id}/${year}/${month}/${day}/`;
        const listParams = { Bucket: bucketName, Prefix };
        try {
          const listedObjects = new ListObjectsV2Command(listParams);
          const listedObject = await s3Client.send(listedObjects);
          if (!listedObject?.Contents?.length) {
            console.log(`No files found for ${Prefix} in bucket ${bucketName}.`);
          } else {
            console.log('listedObject.Contents', listedObject.Contents);
            for (const element of listedObject.Contents) {
              const deleteParams = {
                Bucket: bucketName,
                Key: element.Key,
              };
              console.log('deleteParams', deleteParams);
              await s3Client.send(new DeleteObjectCommand(deleteParams));
              console.log('cleaned up successfully');
            }
          }
        } catch (error) {
          if (error.name === 'NotFound') {
            console.log(`File ${Prefix} does not exist in bucket ${bucketName}.`);
          } else {
            console.error('Error in getting the json file', error);
          }
        }
      }
    }
  } catch (err) {
    console.error('Error', err);
  }
};
