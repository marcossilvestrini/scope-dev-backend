#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set Go Environment
    Author: Marcos Silvestrini
    Date: 04/04/2025
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Workdir
cd /home/vagrant || exit

# Install dependencies
sudo apt install -y \
wget \
git \
jq

# Install go
LATEST_GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
wget "https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "${LATEST_GO_VERSION}.linux-amd64.tar.gz"
rm "${LATEST_GO_VERSION}.linux-amd64.tar.gz"

# Add Go to PATH and configure GOPATH (if existing, not duplicate)
grep -qxF 'export PATH=$PATH:/usr/local/go/bin' ~/.profile || echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
grep -qxF 'export GOPATH=$HOME/go' ~/.profile || echo 'export GOPATH=$HOME/go' >> ~/.profile
grep -qxF 'export PATH=$PATH:$GOPATH/bin' ~/.profile || echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.profile

# apply changes
source ~/.profile

# Create go application hello-app

## Create directory
mkdir -p ~/go-app-test
cd ~/go-app-test

## initialize go module
go mod init example.com/hello-app

## create main.go
cat > main.go << 'EOF'
package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"runtime"
)

func main() {
	// Usar a porta definida pelo ambiente ou 8080 como padrão
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Manipulador para a rota raiz
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Recebida requisição de %s", r.RemoteAddr)
		fmt.Fprintf(w, "Hello, Magalu! Versão Go: %s\n", runtime.Version())
	})    

	// Manipulador para a rota de verificação de saúde
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "ok")
	})

	// Iniciar o servidor
	log.Printf("Servidor iniciado na porta %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Erro ao iniciar servidor: %v", err)
	}
}
EOF

## compile go application
go build -o hello-app

## execute go application
# ./hello-app &

## test application
# curl -s http://localhost:8080

# Build and Deploy Go Application with Docker

## Create dockerfile
cat > Dockerfile << 'EOF'
# Estágio de compilação
FROM golang:1.24.2 as builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o hello-app

# Estágio de execução
FROM alpine:3.18
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/hello-app .
EXPOSE 8080
CMD ["./hello-app"]
EOF

## Build docker image
docker build -t hello-app:1.0 .

## run docker image
docker run -d -p 8080:8080 hello-app:1.0

## test application
curl -s http://localhost:8080
curl -s http://localhost:8080/health
