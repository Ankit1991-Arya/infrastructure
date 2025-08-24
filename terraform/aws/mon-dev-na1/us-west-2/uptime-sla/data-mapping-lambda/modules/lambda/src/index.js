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

function dailyUptimeSLA(data, frequency) {
  const registeredDataPoints = Object.keys(data).length - 1;
  const expectedDataPoints = Math.floor(60 / frequency) * 24;
  const failedDataPoints = Object.values(data).filter((obj) => obj === 0).length;
  const dailySLA =
    100 -
    ((failedDataPoints + (expectedDataPoints - registeredDataPoints)) / expectedDataPoints) * 100;
  return Number(dailySLA.toFixed(2));
}

async function modifyDailySLA(key, jsonData) {
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: key,
    Body: jsonData,
    ContentType: 'application/json',
  });
  const response = await s3Client.send(command);
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

async function constructDailySLA(jsond) {
  const jsonData = JSON.stringify({ [jsond.day]: jsond.sla });
  const fileName = 'dailySLA.json';
  const key = path.join(jsond.region, jsond.serviceId, jsond.year, jsond.month, fileName);
  const listParams = { Bucket: bucketName, Key: key };
  try {
    const headCommand = new HeadObjectCommand(listParams);
    await s3Client.send(headCommand);
    const listCommand = new GetObjectCommand(listParams);
    const getResponse = await s3Client.send(listCommand);
    const data = await streamToString(getResponse.Body);
    const dailySLA = JSON.parse(data);
    dailySLA.push(jsonData);
    modifyDailySLA(key, jsonData);
    return dailySLA;
  } catch (error) {
    if (error.name === 'NotFound') {
      modifyDailySLA(key, jsonData);
    } else {
      console.error('Error in getting the month json file', error);
    }
  }
}

// Function to get JSON files from S3
exports.handler = async () => {
  try {
    const services = activeServices();
    for (const service of services) {
      const { year, month, day } = constructKey(0);
      const Key = `${service.region}/${service.service_id}/${year}/${month}/${day}/data-points.json`;
      const listParams = { Bucket: bucketName, Key };
      try {
        const headCommand = new HeadObjectCommand(listParams);
        await s3Client.send(headCommand);
        const listCommand = new GetObjectCommand(listParams);
        const getResponse = await s3Client.send(listCommand);
        const data = await streamToString(getResponse.Body);
        const sla = dailyUptimeSLA(JSON.parse(data), service.monitoring_frequency);
        const slaDetails = {
          region: service.region,
          serviceId: String(service.service_id),
          sla,
          day: String(day),
          month: String(month),
          year: String(year),
        };
        await constructDailySLA(slaDetails);
        console.log('DailySLA created successfully');
      } catch (error) {
        if (error.name === 'NotFound') {
          console.log(`File ${Key} does not exist in bucket ${bucketName}.`);
        } else {
          console.error('Error in getting the json file', error);
        }
      }
    }
  } catch (err) {
    console.error('Error', err);
  }
};
