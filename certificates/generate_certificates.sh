#!/bin/bash
export password="changeit"

BOLD=$(tput bold)
CLEAR=$(tput sgr0)

target_dir=generated/
CNF_DIR=config/
ROOT_CA_DIR="$target_dir/rootCA"
ROOT_CA_KEY="$target_dir/rootCA/Root.CA.key"
ROOT_CA_CRT="$target_dir/rootCA/Root.CA.pem"
ROOT_CNF="$CNF_DIR/rootCA/openssl.root.ca.cnf"

SERVER_DIR="$target_dir/server"
SERVER_KEY="$SERVER_DIR/server.key"
SERVER_CSR="$SERVER_DIR/server.csr"
SERVER_CRT="$SERVER_DIR/server.crt"
SERVER_CNF="$CNF_DIR/server/openssl.server.cnf"
SERVER_EXT="$CNF_DIR/server/server_ext.cnf"

CLIENT_DIR="$target_dir/client"
CLIENT_KEY="$CLIENT_DIR/client.key"
CLIENT_CSR="$CLIENT_DIR/client.csr"
CLIENT_CRT="$CLIENT_DIR/client.crt"
CLIENT_CNF="$CNF_DIR/client/openssl.client.cnf"
CLIENT_EXT="$CNF_DIR/client/client_ext.cnf"

STORE="$target_dir/store"
KEYSTORE="$STORE/keystore.p12"
TRUSTSTORE="$STORE/truststore.p12"

rm -rf $target_dir

iterate=($target_dir $ROOT_CA_DIR $SERVER_DIR $CLIENT_DIR $STORE)
for dir in "${iterate[@]}"; do
  [[ ! -d "$dir" ]] && mkdir -p "$dir" \
  && echo -e "${BOLD}directory '$dir' was created ${CLEAR}"
done

echo -e "${BOLD}Generating RSA AES-256 Private Key for Root Certificate Authority${CLEAR}"
openssl genrsa -passout env:password -aes256 -out $ROOT_CA_KEY 4096

echo -e "${BOLD}Generating Certificate for Root Certificate Authority${CLEAR}"
openssl req -x509 -new -nodes -days 1825 -out $ROOT_CA_CRT -config $ROOT_CNF

echo -e "${BOLD}Generating RSA Private Key for Server Certificate${CLEAR}"
openssl genrsa -passout env:password -aes256 -out $SERVER_KEY 4096

echo -e "${BOLD}Generating Certificate Signing Request for Server Certificate${CLEAR}"
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -config $SERVER_CNF

echo -e "${BOLD}Generating Certificate for Server Certificate${CLEAR}"
openssl x509 -req -in $SERVER_CSR -CA $ROOT_CA_CRT -CAkey $ROOT_CA_KEY -CAcreateserial -out $SERVER_CRT -days 1825 -sha256 -extfile $SERVER_EXT

echo -e "${BOLD}Generating RSA Private Key for Client Certificate${CLEAR}"
openssl genrsa -passout env:password -aes256 -out $CLIENT_KEY 4096

echo -e "${BOLD}Generating Certificate Signing Request for Client Certificate${CLEAR}"
openssl req -new -key $CLIENT_KEY -out $CLIENT_CSR -config $CLIENT_CNF

echo -e "${BOLD}Generating Certificate for Client Certificate${CLEAR}"
openssl x509 -req -in $CLIENT_CSR -CA $ROOT_CA_CRT -CAkey $ROOT_CA_KEY -CAcreateserial -out $CLIENT_CRT -days 1825 -sha256 -extfile $CLIENT_EXT

echo -e "${BOLD}Export the certificate and the private key to a PKCS format key store${CLEAR}"
openssl pkcs12 -passin env:password -passout env:password -export -in $SERVER_CRT -out $KEYSTORE -name server -nodes -inkey $SERVER_KEY

echo -e "${BOLD}Create a trust store holding the root CA that signed the client certificate${CLEAR}"
keytool -import -file $ROOT_CA_CRT -alias rootCA -keystore $TRUSTSTORE -storepass $password -noprompt

echo "Done!"