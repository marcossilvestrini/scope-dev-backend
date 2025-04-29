# Kind

Kind é um engine para instalar e configurar um cluster kubernetes para fins de testes e desenvolvimento.

## Criando cluster

```sh
kind create cluster # Default cluster context name is `kind`.
...
kind create cluster --name kind-2
```

## Listando clusters

```sh
kind get clusters
```

## Deletando cluster

```sh
kind delete cluster --name kind-2
```
