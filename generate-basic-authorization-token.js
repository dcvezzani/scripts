#!/Users/dcvezzani/.nvm/versions/node/v16.16.0/bin/node

// Import the Buffer module
const { Buffer } = require('buffer');

// Function to generate Basic Authorization value
function generateBasicAuth(username, password) {
    // Combine username and password with a colon
    const credentials = `${username}:${password}`;
    
    // Encode the credentials in Base64
    const base64Credentials = Buffer.from(credentials).toString('base64');
    
    // Return the Basic Authorization value
    return base64Credentials;
}

// Example usage
// JSON.parse(process.argv[2])
// const {username, password} = JSON.parse(process.argv[2])
const username = process.argv[2];
const password = process.argv[3];

let basicAuthValue = generateBasicAuth(username, password);
// basicAuthValue = 'QWRkaWN0aW9uUmVjb3Zlcnk6OGQ2Yzc0MDYtZDQxZS00ODhmLWJjODItYTRmNGY0MWE0Nzc5'
// console.log(">>>dcv (generate-basic-authorization-token.js, , basicAuthValue:25)", basicAuthValue)

// const base64Buffer = Buffer.from('QWRkaWN0aW9uUmVjb3Zlcnk6OGQ2Yzc0MDYtZDQxZS00ODhmLWJjODItYTRmNGY0MWE0Nzc5', 'base64')
const base64Buffer = Buffer.from(basicAuthValue, 'base64')
const string =  base64Buffer.toString()
// console.log(">>>dcv (generate-basic-authorization-token.js, , string:28)", string)

process.stdout.write(basicAuthValue);


