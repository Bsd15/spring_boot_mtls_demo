# Demo project for Spring mTLS

## Certificates

Run the script [generate_certificates.sh](certificates/generate_certificates.sh) under `certificates/` directory to generate new certificated if required.

Modify the config files present under [config](./certificates/config) director. Config files are placed under corresponding directory.

E.g. 
- [openssl.base.cnf](certificates/config/openssl.base.cnf) is the base config which has all the common config used by rooCA, server and client certificate.
- [openssl.root.ca.cnf](certificates/config/rootCA/openssl.root.ca.cnf) for Root CA config
- [server_ext.cnf](certificates/config/server/server_ext.cnf) for x509 extension 

## Access the HTTPS Endpoint

### Bruno

A collection for the API client Bruno has been provided in the directory [bruno](bruno). You can import the collection and modify the client certificate paths and test the endpoint.

### Postman
Try to access the endpoint https://localhost:8443/ssl-demo via postman.

## References

- [How to enable mutual TLS in a Spring Boot Application](https://medium.com/@salarai.de/how-to-enable-mutual-tls-in-a-sprint-boot-application-77144047940f)
- [Https with TLS and springboot - Java Expert (YouTube video)](https://www.youtube.com/watch?v=wxehZYeRWSk)
- [Add and manage CA and client certificates in Postman](https://learning.postman.com/docs/sending-requests/authorization/certificates/)
- [Shell script to generate certificate OpenSSL [No Prompts]](https://www.golinuxcloud.com/shell-script-to-generate-certificate-openssl/)