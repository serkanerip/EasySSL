package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

const CA_CERT_FILE = "../ca.crt"

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		username := r.TLS.VerifiedChains[0][0].Subject.CommonName
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, `{"msg": "Hello, %s!"}`, username)
	})

	caCertFile, _ := ioutil.ReadFile(CA_CERT_FILE)
	certPool := x509.NewCertPool()
	certPool.AppendCertsFromPEM(caCertFile)

	server := &http.Server{Addr: ":443", TLSConfig: &tls.Config{
		ClientAuth: tls.RequireAndVerifyClientCert,
		ClientCAs:  certPool,
		MinVersion: tls.VersionTLS12,
	}}

	log.Fatal(server.ListenAndServeTLS(
		"./certs/certificate.crt",
		"./certs/private-key.pem",
	))
}
