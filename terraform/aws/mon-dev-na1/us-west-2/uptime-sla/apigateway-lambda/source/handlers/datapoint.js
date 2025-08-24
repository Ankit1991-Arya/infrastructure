const axios = require('axios');
const moment = require('moment');
exports.handler = async (event,context) => {
    const url = "http://mimir-url/api/prom";
    const tenant = "anonymous";
    const query = "your_query_here";
    
    const headers = {
        "X-Scope-OrgID": tenant
    };
    
    try {
        const response = await axios.post(`${url}/api/v1/query`, { query: query }, { headers: headers });
        const data = response.data;
        responseData(data);
        // Process the data as needed
        return {
            statusCode: 200,
            body: JSON.stringify(data)
        };
    } catch (error) {
        return {
            statusCode: error.response ? error.response.status : 500,
            body: error.message
        };
    }
};


function responseData(data){
    console.info(data);
    return "";
}