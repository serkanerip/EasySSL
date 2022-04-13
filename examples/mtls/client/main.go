package main

import (
	"crypto/tls"
	"crypto/x509"
	"io"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	caCert, _ := ioutil.ReadFile("../ca.crt")
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	cert, err := tls.LoadX509KeyPair(
		"certs/certificate.crt",
		"certs/private-key.pem",
	)
	if err != nil {
		log.Fatalf("server: loadkeys: %s", err)
	}

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs:      caCertPool,
				Certificates: []tls.Certificate{cert},
			},
		},
	}

	response, err := client.Get("https://localhost")
	if err != nil {
		log.Fatal(err)
	}

	bytes, _ := io.ReadAll(response.Body)
	log.Println(string(bytes))
}
