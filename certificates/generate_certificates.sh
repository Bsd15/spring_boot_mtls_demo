#!/bin/bash

BOLD=$(tput bold)
CLEAR=$(tput sgr0)

iterate=(server/ client/)
for dir in "${iterate[@]}"; do
  [[ ! -d "$dir" ]] && mkdir -p "$dir" \
  && echo -e "${BOLD}directory '$dir' was created ${CLEAR}"
done

echo -e "${BOLD}Generating RSA AES-256 Private Key for Root Certificate Authority${CLEAR}"
openssl genrsa -aes256 -out Root.CA.key 4096

echo -e "${BOLD}Generating Certificate for Root Certificate Authority${CLEAR}"
openssl req -x509 -new -nodes -key Root.CA.key -sha256 -days 1825 -out Root.CA.pem

echo -e "${BOLD}Generating RSA Private Key for Server Certificate${CLEAR}"
openssl genrsa -aes256 -out server/server.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Server Certificate${CLEAR}"
openssl req -new -sha256 -key server/server.key -out server/server.csr

echo -e "${BOLD}Generating Certificate for Server Certificate${CLEAR}"
openssl x509 -req -in server/server.csr -CA Root.CA.pem -CAkey Root.CA.key -CAcreateserial -out server/server.crt -days 1825 -sha256

echo -e "${BOLD}Generating RSA Private Key for Client Certificate${CLEAR}"
openssl genrsa -aes256 -out client/client.key 4096

echo -e "${BOLD}Generating Certificate Signing Request for Client Certificate${CLEAR}"
openssl req -new -sha256 -key client/client.key -out client/client.csr

echo -e "${BOLD}Generating Certificate for Client Certificate${CLEAR}"
openssl x509 -req -in client/client.csr -CA Root.CA.pem -CAkey Root.CA.key -CAcreateserial -out client/client.crt -days 1825 -sha256

echo -e "${BOLD}Export the certificate and the private key to a PKCS format key store${CLEAR}"
openssl pkcs12 -export -in server/server.crt -out keystore.p12 -name server -nodes -inkey server/server.key

echo -e "${BOLD}Create a trust store holding the root CA that signed the client certificate${CLEAR}"
keytool -import -file Root.CA.pem -alias rootCA -keystore truststore.p12

echo "Done!"