FROM node:7.5-alpine
RUN apk add --update git
RUN mkdir -p /app
WORKDIR /app
RUN git clone https://github.com/etsy/statsd.git
WORKDIR /app/statsd
RUN npm install hashring --save
ADD entrypoint.sh /entrypoint.sh
ADD set-cluster-nodes.sh /set-cluster-nodes.sh
COPY proxyConfig.js .

EXPOSE 8125/udp 8126

CMD ["/entrypoint.sh"]
