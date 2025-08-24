const axios = require('axios');
//const validateRequestFields = require('../utils/validation');

exports.handler = async (event,context) => {

    // Validate the request fields
    //await validateRequestFields(event);

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
    return "{\"totalRecords\":23,\"totalPages\":3,\"currentPage\":2,\"_links\":{\"self\":\"https://api.example.com/uptime-manager/uptime?pageNumber=2&itemsPerPage=10&skip=0&top=10&orderBy=desc\",\"next\":\"https://api.example.com/uptime-manager/uptime?pageNumber=3&itemsPerPage=10&skip=0&top=10&orderBy=desc\",\"previous\":\"https://api.example.com/uptime-manager/uptime?pageNumber=1&itemsPerPage=10&skip=0&top=10&orderBy=desc\"},\"services\":[{\"serviceId\":\"36b8f84d-df4e-4d49-b662-bcde71a8764f\",\"serviceName\":\"ServiceA\",\"uptime\":99.99,\"area\":\"EU-West\"},{\"serviceId\":\"41b8f84d-df4e-4d49-b662-bcde71a8764f\",\"serviceName\":\"ServiceC\",\"uptime\":99.99,\"area\":\"EU-West\"},{\"serviceId\":\"46b8f84d-df4e-4d49-b662-bcde71a8764f\",\"serviceName\":\"ServiceB\",\"uptime\":99.99,\"area\":\"US-East\"}]}";
}