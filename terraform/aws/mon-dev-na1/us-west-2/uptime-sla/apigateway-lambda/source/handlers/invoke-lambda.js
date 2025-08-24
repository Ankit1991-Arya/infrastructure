/* eslint-disable no-console */
const moment = require('moment');
const { v4: uuidv4 } = require('uuid');

const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const {
  DynamoDBDocumentClient,
  ScanCommand,
  UpdateCommand,
  PutCommand,
} = require('@aws-sdk/lib-dynamodb');

const dynamoDBClient = new DynamoDBClient({ region: 'us-west-2' });
const dynamoDBDocClient = DynamoDBDocumentClient.from(dynamoDBClient);

const primaryTableName = 'service_registry_store';
const secondaryTableName = 'service_dependency_store';

exports.handler = async (event) => {
  try {
    console.log('event', event);
    if (Object.keys(event).length === 0) {
      console.log('Event request empty.');
      return {
        statusCode: 400,
        body: '{"message": "Event request empty"}',
      };
    }

    if (
      event.service_name === '' ||
      event.service_description === '' ||
      event.service_owner_team === '' ||
      event.service_owner_team_POC === '' ||
      event.committed_sla === '' ||
      event.monitoring_frequency === '' ||
      event.region === '' ||
      event.isGlobalService === ''
    ) {
      console.log('Invalid request parameters.');
      return {
        statusCode: 400,
        body: '{"message": "Invalid request parameters"}',
      };
    }

    const { service_name } = event;
    const primaryTableParams = {
      TableName: primaryTableName,
      FilterExpression: 'service_name = :name AND parent_service_id= :parentId',
      ExpressionAttributeValues: {
        ':name': service_name,
        ':parentId': 0, // parent_service_id is 0 for parent services
      },
    };

    try {
      // Check the primary table for the service_name
      const primaryResult = await dynamoDBDocClient.send(new ScanCommand(primaryTableParams));
      if (primaryResult.Items.length > 0) {
        const updateParams = {
          TableName: primaryTableName,
          Key: { service_name },
          UpdateExpression:
            'set #attr1 = :val1, #attr2 = :val2, #attr3 = :val3, #attr4 = :val4, #attr5 = :val5, #attr6 = :val6, #attr7 = :val7, #attr8 = :val8',
          ExpressionAttributeNames: {
            '#attr1': 'service_name',
            '#attr2': 'service_description',
            '#attr3': 'service_owner_team',
            '#attr4': 'service_owner_team_POC',
            '#attr5': 'committed_sla',
            '#attr6': 'monitoring_frequency',
            '#attr7': 'region',
            '#attr8': 'isGlobalService',
          },
          ExpressionAttributeValues: {
            ':val1': service_name,
            ':val2': event.service_description,
            ':val3': event.service_owner_team,
            ':val4': event.service_owner_team_POC,
            ':val5': event.committed_sla,
            ':val6': Number(event.monitoring_frequency),
            ':val7': event.region,
            ':val8': event.isGlobalService,
          },
        };
        await dynamoDBDocClient.send(new UpdateCommand(updateParams));
        console.log('Parent service data updated successfully');
      } else {

        const childPrimaryTableParams = {
          TableName: primaryTableName,
          FilterExpression: 'service_name = :parentId',
          ExpressionAttributeValues: {
            ':parentId': event.parent_service_id,
          },
        };

        const childPrimaryResult = await dynamoDBDocClient.send(new ScanCommand(childPrimaryTableParams));
        if (childPrimaryResult.Items.length > 0) {
          //console.log('Parent service exists, proceeding to insert child service.');
          const parentServiceId = event.parent_service_id ? event.parent_service_id : '';
          const serviceId = uuidv4();
          const insertParams = {
            TableName: primaryTableName,
            Item: {
              service_id: serviceId,
              service_name,
              registration_date: moment().unix().toString(),
              service_description: event.service_description,
              enable_external_status: 'false',
              parent_service_id: parentServiceId,
              is_active: 'true',
              service_owner_team: event.service_owner_team,
              service_owner_team_POC: event.service_owner_team_POC,
              committed_sla: event.committed_sla,
              monitoring_frequency: Number(event.monitoring_frequency),
              region: event.region,
              is_global_service: event.isGlobalService,
            },
          };
          await dynamoDBDocClient.send(new PutCommand(insertParams));
          console.log('Parent service data inserted successfully');

          if (event.parent_service_id) {
            const childParams = {
              TableName: secondaryTableName,
              Item: {
                service_id: uuidv4(),
                dependent_service_id: childPrimaryResult.Items[0].service_id,
                record_creation_date: moment().unix().toString(),
              },
            };
            await dynamoDBDocClient.send(new PutCommand(childParams));
            console.log('Child service data inserted successfully');
          }
        }else{
          const parentServiceId = event.parent_service_id ? event.parent_service_id : '';
          const serviceId = uuidv4();
          const insertParams = {
            TableName: primaryTableName,
            Item: {
              service_id: serviceId,
              service_name,
              registration_date: moment().unix().toString(),
              service_description: event.service_description,
              enable_external_status: 'false',
              parent_service_id: parentServiceId,
              is_active: 'true',
              service_owner_team: event.service_owner_team,
              service_owner_team_POC: event.service_owner_team_POC,
              committed_sla: event.committed_sla,
              monitoring_frequency: Number(event.monitoring_frequency),
              region: event.region,
              is_global_service: event.isGlobalService,
            },
          };
          await dynamoDBDocClient.send(new PutCommand(insertParams));
          console.log('Parent service data inserted successfully');
        }
      }
      return {
        statusCode: 200,
        body: JSON.stringify(event),
      };
    } catch (error) {
      console.error(`Error While process the data:`, error);
      throw error;
    }
  } catch (error) {
    console.error('Error processing records:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal server error', error: error }),
    };
  }
};
