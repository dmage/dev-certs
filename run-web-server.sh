#!/bin/sh
cat <<END
You can try next commands:

curl http://localhost:8080/
curl --cacert "$PWD/output/ca.crt" https://localhost:8443/

END
docker run --rm -i -t \
    -p 8080:80 -p 8443:443 \
    -v "$PWD/output/server/cert.pem:/app/fullchain.pem" \
    -v "$PWD/output/server/key.pem:/app/privkey.pem" \
    mendhak/http-https-echo
