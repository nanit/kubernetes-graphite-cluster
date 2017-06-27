const Api = require('kubernetes-client');
const JSONStream = require('json-stream');
const jsonStream = new JSONStream();
const util = require('util');
const fs = require('fs')
const configFilePath="./proxyConfig.js"
const core = new Api.Core(Api.config.getInCluster());

function changeConfig(endpoints) {
  nodes = endpoints.subsets[0].addresses.map(e => ({host: e.ip, port: 8125, adminport: 8126}));

  currentConfig = fs.readFileSync(configFilePath);
  eval("currentConfig = " + currentConfig);
  currentConfig.nodes = nodes;
  fs.writeFileSync(configFilePath, util.inspect(currentConfig));
}

core.ns.endpoints.get('statsd-daemon', function(err, result) {
  console.log(JSON.stringify(result))
  changeConfig(result)
})

const stream = core.endpoints.get({qs: {watch: true, fieldSelector: 'metadata.name=statsd-daemon'}})
stream.pipe(jsonStream);
jsonStream.on('data', obj => {
  console.log('Received update:', JSON.stringify(obj, null, 2));
  changeConfig(obj.object);
});

