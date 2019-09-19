#!/bin/sh
USER=user
PASSWORD=qwerty
cat <<END
You can try next commands:

http_proxy='http://user:qwerty@localhost:3128' curl http://httpbin.org/get
http_proxy='https://user:qwerty@localhost:3130' curl --proxy-cacert "$PWD/output/ca.crt" http://httpbin.org/get
https_proxy='http://user:qwerty@localhost:3128' curl https://httpbin.org/get
https_proxy='https://user:qwerty@localhost:3130' curl --proxy-cacert "$PWD/output/ca.crt" https://httpbin.org/get

END
htpasswd -cb ./output/squid.htpasswd "$USER" "$PASSWORD"
docker run --rm -i -t \
    -p 3128:3128 -p 3130:3130 \
    -v "$PWD/output/squid.htpasswd:/etc/squid/passwords" \
    -v "$PWD/output/server/cert.pem:/etc/squid/certs/squid-server.cert.pem" \
    -v "$PWD/output/server/key.pem:/etc/squid/certs/squid-server.key.pem" \
    -v "$PWD/output/ca.crt:/etc/squid/certs/ca-chain.cert.pem" \
    dmage/squid
