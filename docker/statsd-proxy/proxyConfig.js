{
nodes: [
{host: 'statsd-daemon-0.statsd-daemon', port: 8125, adminport: 8126},
{host: 'statsd-daemon-1.statsd-daemon', port: 8125, adminport: 8126}
],
server: './servers/udp',
host:  '0.0.0.0',
port: 8125,
mgmt_port: 8126,
forkCount: 0,
checkInterval: 1000,
cacheSize: 10000
}

