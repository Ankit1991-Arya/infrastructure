const { S3Client, HeadObjectCommand, GetObjectCommand, PutObjectCommand } = require("@aws-sdk/client-s3");
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, ScanCommand } = require("@aws-sdk/lib-dynamodb");

const bucketName = 'uptime-datapoints';
const primarTableName = 'service_registry_store';

let region, service_name, status, getTimeStamp;

const s3Client = new S3Client({ region: process.env.region || "us-west-2" });
const dynamoDBClient = new DynamoDBClient({ region: process.env.region || "us-west-2" });
const dynamoDBDocClient = DynamoDBDocumentClient.from(dynamoDBClient);

exports.handler = async (event) => {
  try {
    for (const record of event.Records) {
      const payload = JSON.parse(record.body);
      console.log('Decoded payload:', payload);

      const data = payload;
      region = process.env.region || "us-west-2";
      service_name = data.service_name;
      status = data.status;
      getTimeStamp = data.timestamp;

      // Validate required parameters
      if (!service_name || !status || !getTimeStamp) {
        console.error('Missing required parameters:', { service_name, status, getTimeStamp });
        continue; // Skip this record and move to the next one
      }
      const timestamp = new Date().toISOString();
      const datePath = timestamp.split('T')[0].replace(/-/g, '/'); // Format: YYYY/MM/DD

      // Validate access permission
      const hasAccess = await validateAccess(service_name);
      if (hasAccess) {
        let updated_service_id = await getDynomoServiceId(service_name);
        await checkUpdateData(region, updated_service_id, datePath, getTimeStamp, status);
      }
    }

    return `Successfully processed ${event.Records.length} records.`;
  } catch (error) {
    console.error('Error processing records:', error);
    return null;
  }
}

async function checkUpdateData(region, updated_service_id, datePath, getTimeStamp, status) {
  const datapointsKey = `${region}/${updated_service_id}/${datePath}/data-points.json`;
  const params = {
    Bucket: bucketName,
    Key: datapointsKey
  };
  try {
    const headCommand = new HeadObjectCommand(params);
    await s3Client.send(headCommand);
    const listCommand = new GetObjectCommand(params);

    const getResponse = await s3Client.send(listCommand);
    const existingData = await streamToString(getResponse.Body);
    console.log("Getting the S3 Load data", existingData);
    const data = await updateDatapointsData(existingData, getTimeStamp, status);
    await storeDatapointsJson(datapointsKey, data);
    return true;

  } catch (error) {
    let newData = {};
    const data = await updateDatapointsData(newData, getTimeStamp, status);
    await storeDatapointsJson(datapointsKey, data);
    return true;
  }
}

function isEmptyObject(obj) {
  return Object.keys(obj).length === 0;
}

async function validateAccess(service_name) {
  var primaryTableParams = {
    TableName: primarTableName,
    FilterExpression: "service_name = :name",
    ExpressionAttributeValues: {
      ":name": service_name
    }
  };
  try {
    const primaryResult = await dynamoDBDocClient.send(new ScanCommand(primaryTableParams));
    if (primaryResult.Items.length > 0) {
      return true; // Record found in the primary table
    }
  } catch (error) {
    console.error(`Error validating access for service Name ${service_name}:`, error);
    throw error;
  }
}

async function getDynomoServiceId(service_name) {
  var primaryTableParams = {
    TableName: primarTableName,
    FilterExpression: "service_name = :name",
    ExpressionAttributeValues: {
      ":name": service_name
    },
    ProjectionExpression: "service_id" // Add this line to select service_id
  };
  try {
    const primaryResult = await dynamoDBDocClient.send(new ScanCommand(primaryTableParams));
    if (primaryResult.Items.length > 0) {
      const serviceId = primaryResult.Items[0].service_id;
      console.log("Service ID:", serviceId);
      return serviceId;
    } else {
      console.log("No matching service found.");
      return null;
    }
  } catch (err) {
    console.error("Unable to scan the table. Error JSON:", JSON.stringify(err, null, 2));
    return null;
  }
}

// Function to convert stream to string
const streamToString = (stream) =>
  new Promise((resolve, reject) => {
    const chunks = [];
    stream.on('data', (chunk) => chunks.push(chunk));
    stream.on('error', reject);
    stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf-8')));
  });

async function updateDatapointsData(existingData, timestamp, status) {
  let data;
  try {
    data = JSON.parse(existingData);
  } catch (e) {
    data = {};
  }

  if (isEmptyObject(data)) {
    console.log("The JSON object is empty.");
    data = {};
  } else {
    if (data.hasOwnProperty(timestamp)) {
      console.log(`Timestamp ${timestamp} already exists with status: ${data[timestamp]}`);
      return data; // Return the existing data without changes
    }
  }
  // Add new timestamp-status pair
  data[timestamp] = status;
  // Update the 'latest' key
  data["latest"] = status;
  return data;
}

async function storeDatapointsJson(datapointsKey, data) {
  let datapointsData = JSON.stringify(data);
  const params = {
    Bucket: bucketName,
    Key: datapointsKey,
    Body: datapointsData,
    ContentType: 'application/json'
  };
  console.log("Data points data ", datapointsData);
  try {
    await s3Client.send(new PutObjectCommand(params));
    console.log(`Successfully stored for ${datapointsKey}`);
  } catch (error) {
    console.error(`Error storing data-points.json:`, error);
    throw error;
  }
}