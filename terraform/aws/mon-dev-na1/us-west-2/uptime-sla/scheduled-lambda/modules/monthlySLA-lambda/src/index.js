/* eslint-disable no-return-await */
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
    console.log('activeServicesList', activeServicesList);
    return activeServicesList;
  } catch (error) {
    console.log('Could not retrieve active services');
  }
};

function constructKey(months) {
  const currentDate = new Date();
  const previousMonth = new Date(currentDate);
  previousMonth.setMonth(currentDate.getMonth() - months);
  const month = (previousMonth.getMonth() + 1).toString().padStart(2, '0');
  const year = previousMonth.getFullYear().toString();
  return {
    year,
    month,
  };
}

function monthlyUptimeSLA(data, month, year) {
  const sumofSLAs = Object.values(data).reduce((acc, value) => +acc + +value, 0);
  const numberofDays = new Date(year, month, 0).getDate();
  return Number((sumofSLAs / numberofDays).toFixed(2));
}

async function modifyMonthlySLA(key, jsonData) {
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: key,
    Body: JSON.stringify(jsonData),
    ContentType: 'application/json',
  });
  const response = await s3Client.send(command);
  console.log('response modifyMonthlySLA', response);
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

async function constructMonthlySLA(jsond) {
  const jsonData = { [jsond.month]: jsond.sla };
  const fileName = 'monthlySLA.json';
  const key = path.join(jsond.region, jsond.serviceId, jsond.year, fileName);
  const listParams = { Bucket: bucketName, Key: key };
  try {
    const headCommand = new HeadObjectCommand(listParams);
    await s3Client.send(headCommand);
    const listCommand = new GetObjectCommand(listParams);
    const getResponse = await s3Client.send(listCommand);
    const data = await streamToString(getResponse.Body);
    const monthlySLA = JSON.parse(data);
    console.log('monthlySLA', monthlySLA);
    const updatedSLA = { ...monthlySLA, ...jsonData };
    await modifyMonthlySLA(key, updatedSLA);
    return monthlySLA;
  } catch (error) {
    if (error.name === 'NotFound') {
      return await modifyMonthlySLA(key, jsonData);
    }
    console.error('Error in getting the month json file', error);
  }
}

// Function to get JSON files from S3
exports.handler = async () => {
  try {
    const services = await activeServices();
    for (const service of services) {
      const { year, month } = constructKey(1);
      const Key = `${service.region}/${service.service_id}/${year}/${month}/dailySLA.json`;
      const listParams = { Bucket: bucketName, Key };
      try {
        const headCommand = new HeadObjectCommand(listParams);
        await s3Client.send(headCommand);
        const listCommand = new GetObjectCommand(listParams);
        const getResponse = await s3Client.send(listCommand);
        console.log('getResponse', getResponse);
        const data = await streamToString(getResponse.Body);
        console.log('data', data);
        const sla = monthlyUptimeSLA(JSON.parse(data), month, year);
        console.log('sla', sla);
        const slaDetails = {
          region: service.region,
          serviceId: String(service.service_id),
          sla,
          month: String(month),
          year: String(year),
        };
        console.log('slaDetails', slaDetails);
        await constructMonthlySLA(slaDetails);
        console.log('MonthlySLA created successfully');
      } catch (error) {
        if (error.name === 'NotFound') {
          console.log(`File ${Key} does not exist in bucket ${bucketName}.`);
          const slaDetails = {
            region: service.region,
            serviceId: String(service.service_id),
            sla: 0,
            month: String(month),
            year: String(year),
          };
          console.log('slaDetails', slaDetails);
          await constructMonthlySLA(slaDetails);
          console.log('MonthlySLA created successfully');
        } else {
          console.error('Error in getting the json file', error);
        }
      }
    }
  } catch (err) {
    console.error('Error', err);
  }
};
