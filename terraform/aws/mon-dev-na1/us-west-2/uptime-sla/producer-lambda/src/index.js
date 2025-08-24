/* eslint-disable no-plusplus */
/* eslint-disable no-console */
const { S3Client, PutObjectCommand, ListObjectsV2Command, DeleteObjectCommand, GetObjectCommand } = require('@aws-sdk/client-s3');
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, ScanCommand, UpdateCommand } = require('@aws-sdk/lib-dynamodb');
const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

const sqsClient = new SQSClient({ region: 'us-west-2' });


const clientdb = new DynamoDBClient({ region: 'us-west-2' });
const docClient = DynamoDBDocumentClient.from(clientdb);

// Define the S3 bucket and folders
const bucketName = 'uptime-datapoints';
const client = new S3Client({ region: 'us-west-2' });

function generateData(date) {
  const data = {};
  const startTime = new Date(date).getTime(); // Get Unix timestamp
  const max = (60/5)*24;
  for (let i = 0; i < max; i++) {
    const value = Math.floor(Math.random() * 2);
    data[startTime + i * (5 *60 * 1000)] = value;
    // console.log(startTime + i * 3600000, value);
  }
  data.latest = Math.floor(Math.random() * 2);
  return data;
}

async function uploadToS3(bucketName, serviceName, date, data) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const filePath = `us-west-2/${serviceName}/${year}/${month}/${day}/data-points.json`;
  // bucketname: uptime-datapoints
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: filePath,
    Body: JSON.stringify(data),
    ContentType: 'application/json',
  });

  try {
    await client.send(command);
    console.log(`Successfully uploaded data to ${filePath}`);
  } catch (error) {
    console.error(`Error uploading data: ${error.message}`);
  }
}

async function addMultipeDatas(all_data) {
  const { cur_date, days, serviceName } = all_data;
  const bucketName = 'uptime-datapoints';
  const startDate = new Date(cur_date);

  for (let i = 0; i < days; i++) {
    // do it for 5 days first then 40
    const date = new Date(startDate);
    date.setDate(startDate.getDate() + i);
    const data = generateData(date);
    console.log(date, data);
    console.log('\n ---------------- \n');
    await uploadToS3(bucketName, serviceName, date, data);
  }
}

async function addMultipeDatasNew(all_data) {
  const { cur_date, days, serviceName } = all_data;
  const bucketName = 'uptime-datapoints';
  const startDate = new Date(cur_date);
  console.log("serviceName", serviceName)
  for (let i = 0; i < days; i++) {
    // do it for 5 days first then 40
    const date = new Date(startDate);
    date.setDate(startDate.getDate() + i);
    const data = generateData(date);
    console.log(date, data);
    console.log('\n ---------------- \n', serviceName);
    await uploadToS3(bucketName, serviceName, date, data);
  }
}

async function deleteEntireObjfromS3(data) {
  const { Prefix } = data;
  const listParams = { Bucket: bucketName, Prefix };
  try {
    const listedObjects = new ListObjectsV2Command(listParams);
    const listedObject = await client.send(listedObjects); 
    if (!listedObject?.Contents?.length) {
      console.log(`No files found for ${Prefix} in bucket ${bucketName}.`);
    } else {
      for (const element of listedObject.Contents) {
        const deleteParams = {
          Bucket: bucketName,
          Key: element.Key,
        };
        await client.send(new DeleteObjectCommand(deleteParams));
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

async function deletePathObjfromS3(data) {
  const { paths } = data;
  for (const path of paths) {
    try {
      const deleteParams = {
        Bucket: bucketName,
        Key: path,
      };
      await client.send(new DeleteObjectCommand(deleteParams));
      console.log('cleaned up successfully');  
    } catch (error) {
      if (error.name === 'NotFound') {
        console.log(`File ${Prefix} does not exist in bucket ${bucketName}.`);
      } else {
        console.error('Error in getting the json file', error);
      }
    }
  }
}

async function putData(data) {
  if (!data?.serviceId) return { status: 400, body: 'serviceId is required' };
  const { serviceId, year, month, day, dataPoints } = data;
  const putS3data = new PutObjectCommand({
    Bucket: bucketName,
    Key: `us-west-2/${serviceId}/${year}/${month}/${day}/data-points.json`,
    Body: JSON.stringify(dataPoints),
    ContentType: 'application/json',
  });
  const response = await client.send(putS3data);
  return response;
}

function getDaysInMonth(year, month) {
  const days = {};
  const date = new Date(year, month - 1, 1); // month is 0-indexed

  while (date.getMonth() === month - 1) {
    const randomInt = Math.random() * (99 - 98 + 1) + 98;
    days[date.getDate().toString().padStart(2, '0')] = randomInt.toFixed(2);
    date.setDate(date.getDate() + 1);
  }

  return days;
}

async function putDataMonth(data) {
  if (!data?.serviceId) return { status: 400, body: 'serviceId is required' };
  const { serviceId, year, month } = data;
  const dataPoints = getDaysInMonth(year, month);
  const putS3data = new PutObjectCommand({
    Bucket: bucketName,
    Key: `us-west-2/${serviceId}/${year}/${month}/dailySLA.json`,
    Body: JSON.stringify(dataPoints),
    ContentType: 'application/json',
  });
  const response = await client.send(putS3data);
  console.log("response ----------------------", response)
  return response;
}


function generateTimestamp(data) {
  if (!data?.date) return { status: 400, body: 'date is required' };
  const { date, fequency } = data;
  const times = {};
  const max = (60/fequency)*24;
  const startTime = new Date(date).getTime();
  for (let i = 0; i < max; i++) {
    times[startTime + i * (fequency * 60 * 1000)] = 1;
  }
  times.latest = 1;
  console.log(times);
  return times;
}

async function listActiveServices() {
   try {
      const params = {
        TableName: 'service_registry_store',
        // FilterExpression: '#is_active = :statusValue',
        // ExpressionAttributeNames: {
        //   '#is_active': 'is_active',
        // },
        // ExpressionAttributeValues: {
        //   ':statusValue': 'TRUE',
        // },
      };
      const data = await docClient.send(new ScanCommand(params));
      const activeServicesList = data.Items;
      console.log("activeServicesList", activeServicesList)
      return activeServicesList;
    } catch (error) {
      console.log('Could not retrieve active services', error);
    }
}

async function listActiveServicesFilter() {
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
     const data = await docClient.send(new ScanCommand(params));
     const activeServicesList = data.Items;
     console.log("activeServicesList", activeServicesList)
     return activeServicesList;
   } catch (error) {
     console.log('Could not retrieve active services', error);
   }
}

const streamToString = (stream) =>
  new Promise((resolve, reject) => {
    const chunks = [];
    stream.on('data', (chunk) => chunks.push(chunk));
    stream.on('error', reject);
    stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf-8')));
  });

async function getJsonData(data) {
  const Key = data.key
  const listParams = { Bucket: bucketName, Key };
  const listCommand = new GetObjectCommand(listParams);
  const getResponse = await client.send(listCommand);
  console.log('getResponse', getResponse);
  const response = await streamToString(getResponse.Body);
  console.log('data', JSON.parse(response));
}

async function addMonthlySLA(data) {
  const { url, dataPoints } = data;
  const putS3data = new PutObjectCommand({
    Bucket: bucketName,
    Key: url,
    Body: JSON.stringify(dataPoints),
    ContentType: 'application/json',
  });
  const response = await client.send(putS3data);
  console.log("response ----------------------", response)
  return response;
}

async function putToSQS(data) {
  const { service_name, timestamp, status } = data;
  const payload = {
    service_name, timestamp, status
  };
  console.log("put sqs payload", payload);
  const params = {
      QueueUrl: 'https://sqs.us-west-2.amazonaws.com/300101013673/uptime-source-queue', // Replace with your queue URL
      MessageBody: JSON.stringify(payload) // The message you want to send
  };
  const dataRes = await sqsClient.send(new SendMessageCommand(params));
  console.log("Success", dataRes.MessageId);
  return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Message sent successfully', messageId: dataRes.MessageId })
  };
}

async function updateDynamoDB(data) {
  try {
    const primaryTableName = 'service_registry_store';
    const { service_name, value } = data;
    const updateParams = {
      TableName: primaryTableName,
      Key: { service_name },
      UpdateExpression: "set #attr1 = :val1",
      ExpressionAttributeNames: {
          "#attr1": 'is_active',
      },
      ExpressionAttributeValues: {
          ":val1": value,
      }
      };
      await docClient.send(new UpdateCommand(updateParams));
      console.log('service data updated successfully');
  } catch (error) {
    console.log("error in dynamodb -----------------", error)
  }
}

async function updateDynamoDBAllData(data) {
  try {
    const primaryTableName = 'service_registry_store';
    const { service_id, service_name, param, value } = data;
    const updateParams = {
      TableName: primaryTableName,
      Key: {  
        "service_id": service_id,
        "service_name": service_name
      },
      UpdateExpression: "set #attr1 = :val1",
      ExpressionAttributeNames: {
          "#attr1": param,
      },
      ExpressionAttributeValues: {
          ":val1": value,
      }
      };
      await docClient.send(new UpdateCommand(updateParams));
      console.log('service data updated successfully');
  } catch (error) {
    console.log("error in dynamodb -----------------", error)
  }
}

async function updateDynamoDBPartition(data) {
  try {
    const primaryTableName = 'service_registry_store';
    const { service_id, param, value } = data;
    const updateParams = {
      TableName: primaryTableName,
      Key: {  
        "service_id": service_id
      },
      UpdateExpression: "set #attr1 = :val1",
      ExpressionAttributeNames: {
          "#attr1": param,
      },
      ExpressionAttributeValues: {
          ":val1": value,
      }
      };
      await docClient.send(new UpdateCommand(updateParams));
      console.log('service data updated successfully');
  } catch (error) {
    console.log("error in dynamodb -----------------", error)
  }
}

exports.handler = async (event) => {

  console.log(JSON.stringify(`Event: event`));
  try {
    // await main();
    // await deleteObjfromS3()
    // return {
    //   statusCode: 200,
    //   body: JSON.stringify('Success!'),
    // };
    if (!event.type) {
      return { statusCode: 400, body: 'No type provided' };
    }
    const obj = {
      putData,
      generateTimestamp,
      addMultipeDatas,
      addMultipeDatasNew,
      deletePathObjfromS3,
      listActiveServices,
      listActiveServicesFilter,
      putDataMonth,
      getJsonData,
      addMonthlySLA,
      putToSQS,
      deleteEntireObjfromS3,
      updateDynamoDB,
      updateDynamoDBAllData,
      updateDynamoDBPartition
    };
    const triggerEvent = obj[event.type];
    return await triggerEvent?.(event);
  } catch (error) {
    console.error(error);
    return {
      statusCode: 200,
      body: JSON.stringify(error.getMessage()),
    };
  }
};

