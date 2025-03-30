#!/bin/bash

mkdir -p certs

cat > certs/openssl-san.cnf <<EOF
[ req ]
default_bits       = 2048
default_md         = sha256
prompt             = no
distinguished_name = dn
x509_extensions    = v3_req

[ dn ]
C  = BR
ST = SP
L  = SaoPaulo
O  = Dev
OU = Dev
CN = example.com

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = example.com
DNS.2 = www.example.com
DNS.3 = localhost
EOF

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/key.pem \
  -out certs/cert.pem \
  -config certs/openssl-san.cnf \
  -extensions v3_req

echo "✅ Certificados gerados em: certs/cert.pem e certs/key.pem"
