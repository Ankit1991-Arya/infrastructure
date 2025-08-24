/* eslint-disable no-console */
const {
  S3Client,
  HeadObjectCommand,
  GetObjectCommand,
  PutObjectCommand,
} = require('@aws-sdk/client-s3');
const path = require('path');

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
    return activeServicesList;
  } catch (error) {
    console.log('Could not retrieve active services');
  }
};

function constructKey(days) {
  const currentDate = new Date();
  const previousDate = new Date(currentDate);
  previousDate.setDate(currentDate.getDate() - days);
  const month = (previousDate.getMonth() + 1).toString().padStart(2, '0');
  const year = previousDate.getFullYear().toString();
  const day = previousDate.getDate().toString().padStart(2, '0');
  return {
    year,
    month,
    day,
  };
}



async function modifyStatusJson( jsonData) {
  let key = "status.json";
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: key,
    Body: jsonData,
    ContentType: 'application/json',
  });
  const response = await s3Client.send(command);
  console.log("File written succ");
  return response;
}

// Function to convert stream to string
const streamToString = (stream) =>
  new Promise((resolve, reject) => {
    const chunks = [];
    stream.on('data', (chunk) => chunks.push(chunk));
    stream.on('error', reject);
    stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf-8')));
  });

async function constructLatestServices(latestJsonData) {
  const jsonData = JSON.stringify(latestJsonData);
  const fileName = 'status.json';
  const listParams = { Bucket: bucketName, Key: fileName };
  try {
    const headCommand = new HeadObjectCommand(listParams);
    await s3Client.send(headCommand);
    console.log('existing',jsonData);
    await modifyStatusJson( jsonData);
  } catch (error) {
    if (error.name === 'NotFound') {
      console.log('new',jsonData);
      await modifyStatusJson(jsonData);
    } else {
      console.error('Error in getting the month json file', error);
    }
  }
}

// Function to get JSON files from S3
exports.handler = async () => {
  try {
    const services = await activeServices();
    console.log('services',services);
    let serviceObj = {};
    for (const service of services) {
      let { year, month, day } = constructKey(0);
      let Key = `${service.region}/${service.service_id}/${year}/${month}/${day}/data-points.json`;
      let listParams = { Bucket: bucketName, Key };
      try {
        let headCommand = new HeadObjectCommand(listParams);
        await s3Client.send(headCommand);
        let listCommand = new GetObjectCommand(listParams);
        let getResponse = await s3Client.send(listCommand);
        let dataString = await streamToString(getResponse.Body);
        let data = JSON.parse(dataString);
        console.log("get Data", data);
        let getServiceValue  = data.latest;
        console.log("service_id,latestva", service.service_id,getServiceValue);
        serviceObj[service.service_id] = getServiceValue? parseInt(getServiceValue) : 0;

    
      } catch (error) {
        if (error.name === 'NotFound') {
          console.log(`File ${Key} does not exist in bucket ${bucketName}.`);
        } else {
          console.error('Error in getting the json file', error);
        }
      }
    }
    console.log("ServiceObj", serviceObj);
    await constructLatestServices(serviceObj)
  } catch (err) {
    console.error('Error', err);
  }
};
