const fs = require('fs');
const util = require('util');
const Client = require('kubernetes-client').Client;
const config = require('kubernetes-client').config;
const client = new Client({ config: config.getInCluster() });
const JSONStream = require('json-stream');
const jsonStream = new JSONStream();
const configFilePath = "./proxyConfig.js"
const namespace = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/namespace', 'utf8').toString();

function getNodes(endpoints) {
  return endpoints.subsets ? endpoints.subsets[0].addresses.map(e => ({ host: e.ip, port: 8125, adminport: 8126 })) : [];
}

function changeConfig(endpoints) {
  currentConfig = fs.readFileSync(configFilePath);
  eval("currentConfig = " + currentConfig);
  currentConfig.nodes = getNodes(endpoints);
  fs.writeFileSync(configFilePath, util.inspect(currentConfig));
}

async function main() {
  await client.loadSpec();
  const stream = client.apis.v1.ns(namespace).endpoints.getStream({ qs: { watch: true, fieldSelector: 'metadata.name=statsd-daemon' } });
  stream.pipe(jsonStream);
  jsonStream.on('data', obj => {
    if (!obj) {
      return;
    }
    console.log('Received update:', JSON.stringify(obj));
    changeConfig(obj.object);
  });
}

try {
  main();
} catch (error) {
  console.error(error);
  process.exit(1);
}
