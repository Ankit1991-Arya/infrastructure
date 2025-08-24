//import axios from 'axios';
//import moment from 'moment';
//import { SQSClient, SendMessageCommand } from '@aws-sdk/client-sqs';
const axios = require('axios');
const moment = require('moment');
const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

const sqsClient = new SQSClient({ region: 'us-west-2' });

async function pushToSQS(status,timestamp) {

    const queueData = {
        service_name: 'inContact MediaServiceOtelCollector',
        status: status,
        timestamp: timestamp,
    };
    const sqsParams = {
        QueueUrl: process.env.QUEUE ?? 'https://sqs.us-west-2.amazonaws.com/300101013673/uptime-source-queue',
        MessageBody: JSON.stringify(queueData),
    };

    const sqsCommand = new SendMessageCommand(sqsParams);
    return sqsClient.send(sqsCommand);
}

const fetchData = async (config) => {
    try {
        const response = await axios(config);
        console.log(response.data);
        console.log("==>>>>", response.data.results.A.frames[0].data);
        const data = response.data.results.A.frames[0].data.values;
        console.log("==>>>>", data, data[0], data[1]);
        
        // Checking second index of data[1] as it is latest value
        if (Array.isArray(data[1]) && data[1].length > 1) {
            console.log("Second index of data[1]:", data[1][1]);
            return { status : data[1][1],timestamp : data[0][1] };
        } else {
            return { status : data[1][0],timestamp : data[1][0] }; //data[1][0];
        }

    } catch (error) {
        console.error(error);
    }
};

exports.handler = async (event, context) => {
    console.log('Event:', JSON.stringify(event, null, 2));

    try {
        process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0'; 
        const from = moment().subtract(5, "seconds").unix() * 1000;
        const to = moment().unix() * 1000;
        console.log("from", from);
        console.log("to", to);

        //either service_name or job name
        const config = {
            method: 'post',
            url:  process.env.URL ?? 'https://grafana-ingress-623632499.us-west-2.elb.amazonaws.com/api/ds/query',
            headers: {
                "Authorization": 'Bearer '+ process.env.TOKEN,
                "Host" : "mon-na1.nicecxone-dev.com"
            },
            data: {
                'queries': [
                    {
                        'datasource': {
                            'type': 'prometheus',
                            'uid': 'mimir'
                        },
                        'expr': 'up{job=~\"HealthWatcherMetric\"}',
                        'intervalMs': 2000,
                        'maxDataPoints': 1
                    }
                ],
                'from': from.toString(),
                'to': to.toString()
            }
        };

        let statusData = await fetchData(config);
        console.log("STATUS FOR SERVICE",statusData);
        await pushToSQS(statusData.status, statusData.timestamp);
        console.log("Pushed to SQS:", statusData.status, statusData.timestamp);

        const response = {
            statusCode: 200,
            body: JSON.stringify(statusData),
        };
        return response;
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Internal Server Error', error: error.message }),
        };
    }
};

