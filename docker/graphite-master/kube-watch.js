const fs = require('fs');
const Client = require('kubernetes-client').Client;
const config = require('kubernetes-client').config;
const client = new Client({ config: config.getInCluster() });
const JSONStream = require('json-stream');
const jsonStream = new JSONStream();
const configFileTemplate = "/opt/graphite/webapp/graphite/local_settings.py.template";
const configFileTarget = "/opt/graphite/webapp/graphite/local_settings.py";
const processToRestart = "graphite-webapp"
const configTemplate = fs.readFileSync(configFileTemplate, 'utf8');
const exec = require('child_process').exec;
const namespace = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/namespace', 'utf8').toString();

function restartProcess() {
  exec(`supervisorctl restart ${processToRestart}`, (error, stdout, stderr) => {
    if (error) {
      console.error(error);
      return;
    }
    console.log(stdout);
    console.error(stderr);
  });
}

function getNodes(endpoints) {
  return endpoints.subsets ? endpoints.subsets[0].addresses.map(e => `"${e.ip}:80"`).join(",") : "";
}

function changeConfig(endpoints) {
  var result = configTemplate.replace(/@@GRAPHITE_NODES@@/g, getNodes(endpoints));
  fs.writeFileSync(configFileTarget, result);
  restartProcess();
}

async function main() {
  await client.loadSpec();
  const stream = client.apis.v1.ns(namespace).endpoints.getStream({ qs: { watch: true, fieldSelector: 'metadata.name=graphite-node' } });
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
