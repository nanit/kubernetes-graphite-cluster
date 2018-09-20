FROM node:8-alpine
RUN apk add --update git bash curl jq
RUN mkdir -p /app
WORKDIR /app
RUN git clone https://github.com/etsy/statsd.git
WORKDIR /app/statsd
RUN npm install -g forever
RUN npm install hashring kubernetes-client@5 json-stream --save
COPY * ./

EXPOSE 8125/udp 8126

CMD ["forever", "statsd-proxy.json"]
