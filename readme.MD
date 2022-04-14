# Installation

```sh
git clone git@github.com:serkanerip/EasySSL.git $HOME/.easyssl && \
sudo ln -s  $HOME/.easyssl/bin/easyssl.sh /usr/local/bin/easyssl
````

# Usage

```sh
Syntax: easyssl [options] [args...]
available options:
ca                 Creates a root certificate(CA)
certificate        Creates a certificate
pkcs12             Archive certificate and private key in pkcs12 format
export-pubkey      Export public key from certificate
fingerprint        Get fingerprint of certificate
update             Update the easyssl
help               Shows this message

Examples:
              easyssl ca init
              easyssl certificate server dev.test
              easyssl certificate client example_common_name
              easyssl pkcs12 certificate.crt private.key
              easyssl export-pubkey certificate.crt
              easyssl fingerprint [-sha256,-md5] certificate.pem
```