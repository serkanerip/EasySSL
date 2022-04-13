# Installation

```sh
git clone git@github.com:serkanerip/EasySSL.git $HOME/.easyssl && \
sudo ln -s  $HOME/.easyssl/bin/easyssl.sh /usr/local/bin/easyssl
````

# Usage

```sh
Syntax: easyssl [options] [args...]
available options:
ca            Creates a root certificate(CA)
certificate   Creates a certificate
help          Shows this message

Examples:
              easyssl ca init
              easyssl certificate server dev.test
              easyssl certificate client example_common_name
```