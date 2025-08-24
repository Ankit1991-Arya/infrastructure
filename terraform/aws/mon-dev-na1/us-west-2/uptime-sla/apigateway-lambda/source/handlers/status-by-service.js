const axios = require('axios');
const moment = require('moment');

exports.handler = async (event,context) => {
    
    try {

        const randomBinary = Math.floor(Math.random() * 2);
        console.log(randomBinary); 

        const res = {
            "36b8f84d-df4e-4d49-b662-bcde71a8764f" : (randomBinary) ? "SUCCESS" : "FAILURE",
            "Service A" : !(randomBinary) ? "SUCCESS" : "FAILURE",
        }
        
        return {
            statusCode: 200,
            body: JSON.stringify(res)
        };
    } catch (error) {
        return {
            statusCode: error.response ? error.response.status : 500,
            body: error.message
        };
    }
};

