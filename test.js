const greet = require("./index.js")
console.log ("Running the tests");

if (greet() === "Hello, World"){
    console.log("Test Passed !");
    process.exit(0);
} 
else

{
    console.log ("Test failed");
    process.exit(1);
}