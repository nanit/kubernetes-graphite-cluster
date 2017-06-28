const util = require('util');
const fs = require('fs')
const Api = require('kubernetes-client');
const kube = new Api.Core(Api.config.getInCluster());
const JSONStream = require('json-stream');
const jsonStream = new JSONStream();
const configFileTemplate="/opt/graphite/webapp/graphite/local_settings.py.template";
const configFileTarget="/opt/graphite/webapp/graphite/local_settings.py";
const processToRestart="graphite-webapp"
const configTemplate = fs.readFileSync(configFileTemplate, 'utf8');
const exec = require('child_process').exec;

function restartProcess() {
  exec(`supervisorctl restart ${processToRestart}`, (error, stdout, stderr) => {
    console.log(`out: ${stdout}
      err: ${stderr}`)})
}

function changeConfig(endpoints) {
  nodes = endpoints.subsets[0].addresses.map(e => `"${(e.ip + ':80')}"`).join(",");
  var result = configTemplate.replace(/@@GRAPHITE_NODES@@/g, nodes);
  fs.writeFileSync(configFileTarget, result);
  restartProcess()
}

kube.ns.endpoints.get('graphite-node', function(err, result) {
  console.log(JSON.stringify(result))
  changeConfig(result)
})

const stream = kube.endpoints.get({qs: {watch: true, fieldSelector: 'metadata.name=graphite-node'}})
stream.pipe(jsonStream);
jsonStream.on('data', obj => {
  console.log('Received update:', JSON.stringify(obj, null, 2));
  changeConfig(obj.object);
});

