# THIS HAS A SEPARATE STEP FOR CSR GENERATION

# Create key
echo
echo INFO - creating key
echo
openssl genrsa -des3 -out awx.key 1024

# Create csr
echo
echo INFO - creating csr
echo
openssl req -new -key awx.key -out awx.csr

# Create cert
echo
echo INFO - creating crt
echo
openssl x509 -req -days 365 -in awx.csr -signkey awx.key -out awx.crt

