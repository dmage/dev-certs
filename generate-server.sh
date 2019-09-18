#!/bin/bash
set -eu

openssl_server_config() {
    cat <<END
[req]
distinguished_name = subject
req_extensions = req_ext
default_md = sha256
prompt = no

[subject]
CN = dev-certs@https-$(date +%s)

[req_ext]
END
}

openssl_servers_extfile() {
    cat <<END
[x509_ext]
keyUsage = digitalSignature, keyEncipherment
subjectAltName = @alternate_names

[alternate_names]
DNS.1 = localhost
DNS.2 = localhost.local
IP.1 = 127.0.0.1
END
}

mkdir -p ./output/server || exit $?
openssl genrsa -out ./output/server/key.pem 2048
openssl req -new \
    -key ./output/server/key.pem \
    -config <(openssl_server_config) \
    -out ./output/server/server.csr
# openssl req -in ./output/server/server.csr -text
openssl x509 -req \
    -in ./output/server/server.csr -CA ./output/ca.crt -CAkey ./output/ca.key -CAcreateserial \
    -days 365 -extensions x509_ext -extfile <(openssl_servers_extfile) \
    -out ./output/server/cert.pem
openssl x509 -in ./output/server/cert.pem -noout -text
