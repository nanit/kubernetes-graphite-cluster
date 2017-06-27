const Api = require('kubernetes-client');
const JSONStream = require('json-stream');
const jsonStream = new JSONStream();
const util = require('util');
const fs = require('fs')
const configFileTemplate="/opt/graphite/conf/carbon.conf.template";
const configFileTarget="/opt/graphite/conf/carbon.conf";
const core = new Api.Core(Api.config.getInCluster());
const configTemplate = fs.readFileSync(configFileTemplate);

function changeConfig(endpoints) {
  nodes = endpoints.subsets[0].addresses.map(e => (e.ip + ":2004")).join(",");
  var result = configTemplate.replace(/@@GRAPHITE_NODES@@/g, nodes);
  fs.writeFileSync(configFilePath, result);
}

core.ns.endpoints.get('graphite-node', function(err, result) {
  console.log(JSON.stringify(result))
  changeConfig(result)
})

const stream = core.endpoints.get({qs: {watch: true, fieldSelector: 'metadata.name=graphite-node'}})
stream.pipe(jsonStream);
jsonStream.on('data', obj => {
  console.log('Received update:', JSON.stringify(obj, null, 2));
  changeConfig(obj.object);
});
