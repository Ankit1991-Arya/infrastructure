const { S3Client, GetObjectCommand, ListObjectsV2Command, HeadObjectCommand } = require('@aws-sdk/client-s3');
let region,serviceId,from,to,recent;
const s3Client = new S3Client({ region: process.env.region || "us-west-2" });   
const moment = require('moment');

const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const {
  DynamoDBDocumentClient,
  ScanCommand,
} = require('@aws-sdk/lib-dynamodb');

const dynamoDBClient = new DynamoDBClient({ region: 'us-west-2' });
const dynamoDBDocClient = DynamoDBDocumentClient.from(dynamoDBClient);
let mainFormula = {};

exports.handler = async (event,context) => {
    console.log(">>",event);
    //return {"msg":"ok"};    
    try {
        /*
        {
            "startTime": "2025-02-01",
            "endTime": "2025-02-10",
            "serviceId": "string",
            "area": "string"
        }
        */
        region      = event.area ? event.area.toLowerCase() : "";
        serviceId   = event.serviceId ?? "";
        from        = event.startTime ?? "";
        to          = event.endTime ?? "";
        recent      = event.recent ?? 31;//        

        let flag = (event.flag) ? 1 :0;
        let today = moment();
        if (from == "" || to == "") {
            from = moment().subtract(recent,"days").format("YYYY-MM-DD");
            to = moment().subtract(1,"day").format("YYYY-MM-DD");
        }

        if (region == "" || serviceId == "" || !isValidServiceId(serviceId)) {
            console.log("Invalid request parameters.");
            return {
                statusCode: 400,
                headers: {"Content-Type": "application/json"},
                body: "{\"message\": \"Invalid request parameters\"}",
                isBase64Encoded: false
            };
        }
        const regex = /^\d{4}-\d{2}-\d{2}$/;
        console.log(regex.test(from), regex.test(to));
        if (!regex.test(from) || !regex.test(to) || new Date(from) == "Invalid Date" || new Date(to) == "Invalid Date") {
            console.log("Invalid date");
            return {
                statusCode: 400,
                headers: {"Content-Type": "application/json"},
                body: "{\"message\": \"Invalid date\"}",
                isBase64Encoded: false
            };
        }
        
        let fromDate = moment(from);
        let toDate = moment(to);
        if (fromDate.isAfter(toDate) || fromDate.isAfter(today) || toDate.isAfter(today)) {
            return {
                statusCode: 400,
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({ message: "Invalid date" }),
                isBase64Encoded: false
            };
        }
        
        let folderExists = await validateFolders(region,serviceId);
        if (!folderExists) {
            return {
                statusCode: 400,
                headers: {"Content-Type": "application/json"},
                body: "{\"message\": \"Invalid serviceId or region.\"}",
                isBase64Encoded: false
            };
        } 
        
        
        let checkchilds = await getAllChildData(serviceId);
        console.log("checkchilds",checkchilds);
        let data = checkchilds.allServices.map(item => item.service_id);//all child and parent service ids
        console.log("data",data);
        if (!data || data.length == 0) {
            console.log("No child data found for serviceId:", serviceId);
            serviceId = [serviceId]; // If no child data, use the parent serviceId
        }
        else{
            console.log("ParentchildServiceIds ",data);
            serviceId = data.push(serviceId); // Include the parent serviceId in the list
            serviceId = data.filter((value, index, self) => self.indexOf(value) === index); // Remove duplicates
            console.log("Unique serviceIds",serviceId);
        }
        console.log("serviceId =>>>",serviceId);
        
        let uptime = {};
        let isMonthlySla = checkDatesAndCallMonthlySla(from,to);
        if (!isMonthlySla) {
            //const today = moment();
            const date24MonthsAgo = today.clone().subtract(24, 'months');
            const date90DaysAgo = today.clone().subtract(90, 'days');
            const start = moment(from);
            const end = moment(to);
            console.log(start.format("YYYY-MM-DD"),end.format("YYYY-MM-DD"),date24MonthsAgo.format("YYYY-MM-DD"),date90DaysAgo.format("YYYY-MM-DD"));

            if ((start.isAfter(date24MonthsAgo) && start.isBefore(date90DaysAgo)) || 
                (end.isAfter(date24MonthsAgo) && end.isBefore(date90DaysAgo))) {
                return {
                    statusCode: 400,
                    headers: {"Content-Type": "application/json"},
                    body: "{\"message\": \"Only monthly data can avail if dates not lies in 90 days\"}",
                    isBase64Encoded: false
                };
            } else if (!daysDiffFor90(start, end)) {
                return {
                    statusCode: 400,
                    headers: {"Content-Type": "application/json"},
                    body: "{\"message\": \"Only 90 days data can avail\"}",
                    isBase64Encoded: false
                };
            }
            else
            {
                console.log(from,to,serviceId,region);
                const dates = generateFilePath(from,to,serviceId,region);
                console.log("dates",dates);
                let newDates = await filterExistingS3Paths(dates);
                console.log("newDates",newDates);
                if (Object.keys(newDates).length === 0) {
                    console.log("No data found for the given date range.");
                    return {
                        statusCode: 404,
                        headers: {"Content-Type": "application/json"},
                        body: "{\"message\": \"No data found for the given date range.\"}",
                        isBase64Encoded: false
                    };
                }
                const uptimeData = await readDataFromS3Files(newDates);
                console.log(">>>><<<<<",uptimeData);
                //return uptimeData;
                let avgs = calculateUptime(uptimeData,from,to,checkchilds.relationship);
                console.log("avgs", avgs, ">>>>>>><<<<<<");
                console.log("evaluatedAvg", avgs.evaluatedAvg[event.serviceId.trim()]);
                uptime[event.serviceId.trim()] = avgs.evaluatedAvg[event.serviceId.trim()] || 0;
                uptime["serviceUptimes"] = avgs.serviceUptimes;
                console.log("uptime", uptime);

                //uptime = generateRandomPercentage();
            }
        }
        else{
            //monthly SLA
            const dateArray = getDateArray(new Date(from), new Date(to),region,serviceId);
            console.log("dateArray",dateArray);
            let newDates = await filterExistingS3Paths(dateArray);
            console.log("newDates",newDates);
            const uptimeData = await readDataFromS3Files(newDates,true);
            console.log("uptimeData", uptimeData);
            const avg = monthlySla(from, to, uptimeData,checkchilds.relationship);
            console.log(">>>><<<<<",avg,"avg");
            console.log("evaluatedAvg", avg.evaluatedAvg[event.serviceId.trim()]);
            uptime[event.serviceId.trim()] = avg.evaluatedAvg[event.serviceId.trim()] || 0;
            uptime["serviceUptimes"] = avg.serviceUptimes;
            console.log("uptime", uptime);
            //uptime = avg ?? 0;
        }
        if (uptime[event.serviceId.trim()] === 0) {
            return {
                statusCode: 404,
                headers: {"Content-Type": "application/json"},
                body: "{\"message\": \"No data found for the given date range.\"}",
                isBase64Encoded: false
            };
        }        
        return {
            statusCode: 200,
            headers: {"Content-Type": "application/json"},
            body : JSON.stringify({"uptime": uptime}),
            isBase64Encoded: false
        };
    } catch (error) {
        console.log(error);
        return {
            statusCode: error.response ? error.response.status : 500,
            headers: {"Content-Type": "application/json"},
            body : JSON.stringify({message: error.message}),
            isBase64Encoded: false
        };
    }
}


function generateFilePath(startTime, endTime, serviceId, region) {
    let result = {};
    let start = new Date(startTime);
    let end = new Date(endTime);

    serviceId.forEach(id => {
        result[id] = [];
        let tempDate = new Date(start.getFullYear(), start.getMonth(), 1); 
        let endMonth = end.getMonth();
        let endYear = end.getFullYear();

        while (tempDate.getFullYear() < endYear ||
        (tempDate.getFullYear() === endYear && tempDate.getMonth() <= endMonth)
        ) 
        {
            let year = tempDate.getFullYear();
            let month = String(tempDate.getMonth() + 1).padStart(2, '0');
            //let file = 'dailySLA.json';
            let file;
            if (start.getTime() == end.getTime()) {
                file = start.toISOString().split('T')[0].split('-')[2]+"/data-points.json";
            }
            else{
                file = 'dailySLA.json';
            }
            result[id].push({
                path: `${region}/${id}/${year}/${month}/${file}`
            });
            tempDate.setMonth(tempDate.getMonth() + 1);
        }
    });

    return result;
}

async function readDataFromS3Files(filePathObj, ismonthly = false) {
    try {
        const result = {};
        for (const [key, files] of Object.entries(filePathObj)) {
            result[key] = [];
            const fetchPromises = files.map(async (file) => {
                console.log(">>>", file["path"]);
                const cmd = new GetObjectCommand({
                    Bucket: process.env.Bucket || "uptime-datapoints",
                    Key: file["path"]
                });

                const response = await s3Client.send(cmd);
                const fileData = await response.Body.transformToString();
                const jsonData = JSON.parse(fileData);
                let subKey;
                if (ismonthly) {
                    let match = file["path"].match(/\/(\d{4})\/monthlySLA\.json/);
                    subKey = match[1];
                } else {
                    let match = file["path"].match(/\/(\d{4})\/(\d{2})\/dailySLA\.json/);
                    subKey = `${match[1]}-${match[2]}`;
                }
                return { [subKey]: jsonData };
            });
            result[key] = await Promise.all(fetchPromises);
        }
        console.log("combineData", result);
        return result;
    } catch (error) {
        console.error('S3 Err', error);
        return null;
    }
}

async function filterExistingS3Paths(filePathObj) {
    const updatedFilePathObj = {};
    for (const [serviceId, files] of Object.entries(filePathObj)) {
        const validFiles = [];
        for (const file of files) {
        const cmd = new HeadObjectCommand({
            Bucket: process.env.Bucket || "uptime-datapoints",
            Key: file["path"]
        });
        try {
            await s3Client.send(cmd);
            validFiles.push(file);
        } catch (err) {
            if ((err.name !== "NotFound" && err.$metadata?.httpStatusCode !== 404) &&
            err.Code !== "NotFound") {
                console.error(`Error checking S3 path: ${file["path"]}`, err);
            }
        }
        }
        if (validFiles.length > 0) {
            updatedFilePathObj[serviceId] = validFiles;
        }
    }
    return updatedFilePathObj;
}

function calculateUptime(data, startDate, endDate, relationship) {
    let simplifiedData = simplifyData(data);
    console.log("simplifiedData", simplifiedData);
    let start = new Date(startDate);
    let end = new Date(endDate);
    let serviceUptimes = {};
    let totalUptime = 0;
    let serviceCount = 0;

    for (let serviceId in simplifiedData) {
        let total = 0;
        let count = 0;
        for (let date in simplifiedData[serviceId]) {
            let currentDate = new Date(date);
            if (currentDate >= start && currentDate <= end) {
                total += parseFloat(simplifiedData[serviceId][date]);
                count++;
            }
        }
        let avg = count !== 0 ? (total / count).toFixed(2) : 0;
        serviceUptimes[serviceId] = avg;
        console.log("serviceUptimes",serviceUptimes);
        // Calculate the average of all service uptimes so far
        const sum = Object.values(serviceUptimes).reduce((acc, val) => acc + parseFloat(val), 0);
        serviceUptimes.avg = (sum / Object.keys(serviceUptimes).length).toFixed(2);
        if (count !== 0) {
            totalUptime += parseFloat(avg);
            serviceCount++;
        }
    }

    let overallAvg = serviceCount !== 0 ? (totalUptime / serviceCount).toFixed(2) : 0;
    console.log("Overall Average Uptime:", overallAvg);
    console.log("Service Uptimes:", serviceUptimes);
    console.log("Service Count:", serviceCount);
    console.log("Total Uptime:", totalUptime);
    iterateRelationship(relationship, [],serviceUptimes);
    console.log("Main Formula:", mainFormula);
    let evaluatedAvg = evaluateAvg(mainFormula, serviceUptimes);
    console.log('Evaluated Avg :: ->> ', evaluatedAvg);
    console.log("Final Service Uptimes:", serviceUptimes);
    return {evaluatedAvg,serviceUptimes};
}

function simplifyData(data) {
    let simplifiedData = {};
    for (const serviceId in data) {
        simplifiedData[serviceId] = {};
        data[serviceId].forEach(entry => {
            for (let date in entry) {
                const value = entry[date];
                console.log("date =>>",date,value);
                if (Array.isArray(value)) {
                    // If value is an array, just assign it to the date key
                    console.log("Array.isArray ? ",value);
                    simplifiedData[serviceId][date] = value;
                } else if (typeof value === 'object' && value !== null) {
                    // If value is an object, flatten day keys
                    for (let day in value) {
                        let key = `${date}-${day.padStart(2, '0')}`;
                        simplifiedData[serviceId][key] = value[day];
                    }
                }
            }
        });
    }
    return simplifiedData;
}

async function isprefixExists(prefix){
    try {
        const command = new ListObjectsV2Command({
            Bucket : process.env.Bucket,
            Prefix : prefix,
            MaxKeys: 1
        });
        const res = await s3Client.send(command);
        console.log("isprefixExists",res);
        return res.Contents && res.Contents.length > 0;
    } catch (error) {
        console.log("S3 prefix",error);
        return false;
    }    
}

async function validateFolders(region, serviceId){
    try {
        const regionPrefix = `${region}/`;
        const regionExists = await isprefixExists(regionPrefix);
        if (!regionExists) {
            return false;
        }
        const servicePrefix = `${region}/${serviceId}/`;
        const serviceExists = await isprefixExists(servicePrefix);
        if (!serviceExists) {
            return false;
        }

        return regionExists && serviceExists;

    } catch (error) {
        console.log("validateFolders",error);
        return false;
    }
}


function daysDiffFor90(start, end) {
    return end.diff(start, 'days') <= 90;
}


function checkDatesAndCallMonthlySla(startDate, endDate) {
    const start = new Date(startDate);
    const end = new Date(endDate);
    const now = new Date();

    // Ensure start date is the 1st day of the month and end date is the last day of the month
    const isStartFirstDay = start.getDate() === 1;
    const isEndLastDay = end.getDate() === new Date(end.getFullYear(), end.getMonth() + 1, 0).getDate();
    console.log(">>",isStartFirstDay,isEndLastDay);

    // Check if dates are within the last 24 months
    const monthsDifferenceStart = (now.getFullYear() - start.getFullYear()) * 12 + (now.getMonth() - start.getMonth());
    const monthsDifferenceEnd = (now.getFullYear() - end.getFullYear()) * 12 + (now.getMonth() - end.getMonth());
    console.log(">>>",monthsDifferenceStart,monthsDifferenceEnd);

    if (isStartFirstDay && isEndLastDay && monthsDifferenceStart <= 24 && monthsDifferenceEnd <= 24 && start <= end) {
        //const dateArray = getDateArray(start, end);
        //monthlySla(startDate, endDate, dateArray);
        return true;
    }
    else {
        console.log('Dates are not valid or are older than 24 months.',startDate,endDate);
        return false;
    }
}


function getDateArray(start, end, region, serviceIds = []) {
    const startDate = new Date(start);
    const endDate = new Date(end);
    const result = {};

    serviceIds.forEach(serviceId => {
        const dateArr = [];
        for (let year = startDate.getFullYear(); year <= endDate.getFullYear(); year++) {
            dateArr.push({ "path": `${region}/${serviceId}/${year}/monthlySLA.json` });
        }
        result[serviceId] = dateArr;
    });

    return result;
}

function monthlySla(startDate, endDate, dateArray, relationship) {
    console.log(`Calculating SLA for period: ${startDate} to ${endDate}`);
    console.log('Date Array:', dateArray);
    let start = new Date(startDate);
    let end = new Date(endDate);
    let serviceUptimes = {};
    let totalUptime = 0;
    let serviceCount = 0;

    for (let serviceId in dateArray) {
        let total = 0;
        let count = 0;
        let yearDataArr = dateArray[serviceId];
        console.log("yearDataArr", yearDataArr);
        for (let yearData of yearDataArr) {
            for (let year in yearData) {
                for (let month in yearData[year]) {
                    let currentDate = new Date(`${year}-${month}-01`);
                    console.log("currentDate", currentDate,start, end);
                    if (currentDate >= start && currentDate <= end) {
                        let value = yearData[year][month];
                        total += parseFloat(value);
                        count++;
                    }
                }
            }
        }
        let avg = count !== 0 ? (total / count).toFixed(2) : 0;
        serviceUptimes[serviceId] = avg;
        serviceUptimes.avg = (Object.values(serviceUptimes).reduce((acc, val) => acc + parseFloat(val), 0) / Object.keys(serviceUptimes).length).toFixed(2);
        if (count !== 0) {
            totalUptime += parseFloat(avg);
            serviceCount++;
        }
    }

    let overallAvg = serviceCount !== 0 ? (totalUptime / serviceCount).toFixed(2) : 0;
    serviceUptimes.avg = overallAvg;
    iterateRelationship(relationship, [],serviceUptimes);
    console.log("Main Formula:", mainFormula);
    let evaluatedAvg = evaluateAvg(mainFormula, serviceUptimes);
    console.log('Evaluated Avg :: ->> ', evaluatedAvg);
    console.log("Service Uptimes:", serviceUptimes);
    return {evaluatedAvg, serviceUptimes };
}

function generateRandomPercentage(min=85, max=93) {
    return (Math.random() * (max - min) + min).toFixed(2);
}

function isValidServiceId(serviceId) {
    const length = serviceId.length;
    const hasOnlyAlphanumeric = /^[a-zA-Z0-9]+$/.test(serviceId);
    console.log(length > 35,length < 39, hasOnlyAlphanumeric);
    return true ;//(length > 35 && length < 39); for testing purpose we are allowing all serviceId
}

async function getAllChildData(serviceName = "ServiceA", maxLevel = 3) {
    
    async function fetchChildren(parentId, level) {
        console.log("level", level, "parentId", parentId);
        if (level > maxLevel) return { services: [], tree: {} };
        const params = {
            TableName: 'service_registry_store',
            FilterExpression: '#parentId = :parentValue',
            ExpressionAttributeNames: {
                '#parentId': 'parent_service_id',
            },
            ExpressionAttributeValues: {
                ':parentValue': parentId,
            },
        };
        let children = [];
        let tree = {};
        try {
            const data = await dynamoDBDocClient.send(new ScanCommand(params));
            if (data.Items && data.Items.length > 0) {
                children = data.Items;
                for (const child of children) {
                    const childId = child.service_id;
                    const { services: grandChildren, tree: childTree } = await fetchChildren(childId, level + 1);
                    tree[childId] = childTree;
                    children = children.concat(grandChildren);
                }
            }
        } catch (error) {
            console.log('Could not retrieve data', error);
        }
        console.log("Children at level", level, "for parent", parentId, ":", children);
        console.log("Tree at level", level, "for parent", parentId, ":", tree);
        return { services: children, tree };
    }

    // Start recursion from the root service
    const { services, tree } = await fetchChildren(serviceName, 1);
    // Optionally, include the root in the tree
    const relationship = { [serviceName]: tree };
    console.log("Relationship Tree :: ", relationship);
    console.dir(relationship, { depth: null });
    console.log("All Services ::", services);
    return { allServices: services, relationship };
}

function evaluateAvg(formula, avgMap) {
    // Clone avgMap to avoid mutating the original
    let result = { ...avgMap };
    // Get keys in bottom-up order
    let keys = Object.keys(formula).reverse();
    for (let key of keys) {
        let children = formula[key];
        // Only calculate if all children have values
        console.log(`Evaluating Avg for ${key} with children:`, children);
        let values = children.map(child => parseFloat(result[child]));
        console.log(`Values for ${key}:`, values);
        if (values.every(v => !isNaN(v))) {
            let sum = values.reduce((a, b) => a + b, 0);
            result[key] = (sum / values.length).toFixed(2);
        }
    }
    return result;
}

function iterateRelationship(obj, path = [],avg = {}) {
    for (let key in obj) {
        let currentPath = [...path, key];
        if (typeof obj[key] === 'object' && Object.keys(obj[key]).length > 0) {
        // Add to mainFormula if it has children
            mainFormula[key] = Object.keys(obj[key]);
            if(avg[key]){
                mainFormula[key].push(key);
            }
            console.log(`Adding ${key} to mainFormula with children:`, mainFormula[key]);
            iterateRelationship(obj[key], currentPath,avg);
        }
    }
}