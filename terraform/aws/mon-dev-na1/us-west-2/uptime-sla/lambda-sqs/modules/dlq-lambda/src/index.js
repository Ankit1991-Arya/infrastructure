const { SQSClient, SendMessageCommand } = require('@aws-sdk/client-sqs');

const sqsClient = new SQSClient({ region: 'us-west-2' });

exports.handler = async (event) => {
  try {
      const { service_name, timestamp, status } = event;
      const payload = {
        service_name, timestamp, status
      };
      console.log("put dlq payload", payload);
      const params = {
          QueueUrl: 'https://sqs.us-west-2.amazonaws.com/300101013673/uptime-dlq',
          MessageBody: JSON.stringify(payload) // The message you want to send
      };
      const dataRes = await sqsClient.send(new SendMessageCommand(params));
      console.log("Success", dataRes.MessageId);
      return {
          statusCode: 200,
          body: JSON.stringify({ message: 'Message sent successfully', messageId: dataRes.MessageId })
      };
  } catch (error) {
    console.error('Error processing records:', error);
    return null;
  }
}
