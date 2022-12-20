#!/usr/bin/env bash

# Configuration
set -o allexport
source .env
set +o allexport

if [ "$PUBLIC_DNS" = "" ]; then
    echo "No PUBLIC_DNS"
    exit 0;
fi

mkdir docker-ca
chmod 0700 docker-ca/
cd docker-ca/

# CA key
openssl genrsa -aes256 -out ca-key.pem 4096
# CA certificate
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem

# Server key
openssl genrsa -out server-key.pem 4096
# Server CSR on DNS name
openssl req -subj "/CN=${PUBLIC_DNS}" -sha256 -new -key server-key.pem -out server.csr
# Alts on IPs
echo extendedKeyUsage = serverAuth > extfile.cnf
echo subjectAltName = DNS:${PUBLIC_DNS} >> extfile.cnf
# Server certificate
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

rm -v server.csr extfile.cnf

# Client key
openssl genrsa -out key.pem 4096
# Client CSR
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
# clientAuth
echo extendedKeyUsage = clientAuth > extfile-client.cnf
# Client certificate
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile-client.cnf

rm -v client.csr extfile-client.cnf

# Securing
chmod -v 0400 *-key.pem key.pem
chmod -v 0444 ca.pem *-cert.pem cert.pem
