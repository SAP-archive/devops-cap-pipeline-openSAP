'use strict'
const path = require('path');
const specs = path.relative(process.cwd(), path.join(__dirname, './tests/*.spec.js'));

// Local testing
const baseUrl = "http://localhost:4004/fiori.html#manage-books";

// Remote testing
// const baseUrl = "https://<YOUR_DEPLOYED_APPROUTER_URL>.cfapps.eu10.hana.ondemand.com/app/fiori.html#manage-books";

exports.config = {
  profile: "integration",
  baseUrl: baseUrl,
  specs: specs
};
