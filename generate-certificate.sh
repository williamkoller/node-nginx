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
CN = node-nginx.local

[ v3_req ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = node-nginx.local
DNS.2 = localhost
DNS.3 = node-nginx.com
DNS.4 = 127.0.0.1
IP.1 = 127.0.0.1
EOF

# Remove certificados antigos se existirem
rm -f certs/cert.pem certs/key.pem

# Gera novos certificados
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/key.pem \
  -out certs/cert.pem \
  -config certs/openssl-san.cnf \
  -extensions v3_req

echo "✅ Certificados SSL gerados com sucesso!"
echo "📋 Domínios incluídos no certificado:"
echo "   - node-nginx.local"
echo "   - localhost" 
echo "   - node-nginx.com"
echo "   - 127.0.0.1"
echo ""
echo "📁 Arquivos gerados:"
echo "   - certs/cert.pem"
echo "   - certs/key.pem"
