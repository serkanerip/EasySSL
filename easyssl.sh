EASYSSL_PATH="$HOME/.easyssl"
CONF_PATH="$EASYSSL_PATH/ca.conf"
CA_PATH="$EASYSSL_PATH/ca.crt"
CA_KEY_PATH="$EASYSSL_PATH/ca.key"
SERVER_EXT="$EASYSSL_PATH/certificate.ext"
CLIENT_EXT="$EASYSSL_PATH/client_cer.ext"

mkdir -p $EASYSSL_PATH

if [ "$1" == "" ]; then
    echo "Need command as first argument examples:"
    echo "easyssl ca init"
    echo "easyssl certificate server [host]"
    echo "easyssl certificate client [common_name]"
    exit 0
fi

generate_ca() {
    if [ -f "$CA_PATH" ]; then
        echo "CA already created! If you want new one remove exists one"
        echo "command: rm $CA_PATH"
        exit 0
    fi;
    privpass=""
    read -p "Enter password for private key: " privpass
    if [ "$privpass" == "" ]; then
        echo "password cannot be empty"
        exit 0
    fi;

    openssl genpkey -algorithm RSA -des3 -out $CA_KEY_PATH  -pkeyopt rsa_keygen_bits:4096 -pass pass:$privpass
    echo "Private key created!";

    passwd=""
    read -p "Enter password for certificate: " passwd
    if [ "$passwd" == "" ]; then
        echo "password cannot be empty"
        exit 0
    fi;

    openssl req -x509 -new -config $CONF_PATH -key $CA_KEY_PATH -sha256 -days 3650 -out $CA_PATH -passin pass:$privpass

    echo "Local CA is generated!" 
}

generate_server_certificate() {
    openssl genrsa -out private-key.pem 4096
    echo "Private key created: $(pwd)/private-key.pem"

    openssl req -new -key private-key.pem -out csr.pem \
        -nodes -subj "/C=TR/ST=Bahcivan/L=Van/O=Dis/CN=EasySSLCertificate"
    echo "CSR created: $(pwd)/csr.pem"

    ext=$(cat $SERVER_EXT | sed "s/@host@/$1/g")
    echo "$ext" > tmp_ext
    openssl x509 -req -in csr.pem -CA $CA_PATH -CAkey $CA_KEY_PATH \
        -CAcreateserial -out certificate.crt -days 365 -sha256 -extfile tmp_ext
    echo "Certificate created: $(pwd)/certificate.crt"
}

generate_client_certificate() {
    openssl genrsa -out private-key.pem 4096
    echo "Private key created: $(pwd)/private-key.pem"

    openssl req -new -key private-key.pem -out csr.pem \
        -nodes -subj "/C=TR/ST=Bahcivan/L=Van/O=Dis/CN=$1"
    echo "CSR created: $(pwd)/csr.pem"

    ext=$(echo "$(cat $CLIENT_EXT)")
    echo "$ext" > tmp_ext
    openssl x509 -req -in csr.pem -CA $CA_PATH -CAkey $CA_KEY_PATH \
        -CAcreateserial -out certificate.crt -days 365 -sha256 -extfile tmp_ext
    echo "Certificate created: $(pwd)/certificate.crt"
}

rm tmp_*
if [ "$1 $2" == "ca init" ]; then
    generate_ca
fi;

if [ "$1 $2" == "certificate server" ]; then
    generate_server_certificate $3
fi;

if [ "$1 $2" == "certificate client" ]; then
    generate_client_certificate $3
fi;
rm tmp_*