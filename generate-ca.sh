#!/bin/bash
set -eu

openssl_ca_config() {
    cat <<END
[req]
distinguished_name = subject
x509_extensions = x509_ext
default_md = sha256
prompt = no

[subject]
CN = dev-certs@ca-$(date +%s)

[x509_ext]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints = CA:true
END
}

mkdir -p ./output || exit $?
openssl genrsa -out ./output/ca.key 2048
openssl req -new -x509 \
    -key ./output/ca.key \
    -days 365 -nodes -config <(openssl_ca_config) \
    -out ./output/ca.crt
openssl x509 -in ./output/ca.crt -noout -text
