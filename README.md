
# Guia Desenvolvedor Backend Sênior

## Infraestrutura e Cloud

### 🧱 OpenStack

OpenStack é uma plataforma de código aberto para construção e gerenciamento de ambientes de nuvem pública e privada, criada inicialmente pela NASA e Rackspace em 2010. Hoje é mantida pela OpenInfra Foundation, sendo amplamente utilizada por provedores de cloud, instituições financeiras e grandes corporações para orquestrar infraestrutura como serviço (IaaS).

#### Arquitetura e Componentes Principais

1. ⚙️**Nova (Compute)**
   - Gerencia a criação e execução de máquinas virtuais.
   - Integra-se com o hypervisor (KVM, QEMU, etc).
   - CLI:

     ```bash
     openstack server create --image <imagem> --flavor <tipo> --network <rede> --security-group <grupo> --key-name <chave> <nome_vm>
     openstack server list --project <projetc_id>
     openstack server delete <id_vm>
     openstack server reboot <server_id>
     ```

2. 🌐**Neutron (Networking)**
   - Gerencia redes virtuais, sub-redes, roteadores, e balanceadores de carga.
   - Suporta múltiplos backends como Open vSwitch e Linux Bridge.
   - CLI:

     ```bash
     openstack network create <nome_rede>
     openstack subnet create --network <nome_rede> --subnet-range 192.168.100.0/24 <nome_subrede>
     openstack router create <nome_router>
     openstack router add subnet <nome_router> <nome_subrede>
     
     # Criar um security group
     openstack security group create web-sg --description "Acesso HTTP/HTTPS e SSH"

     # Adicionar regras de segurança
     openstack security group rule create --proto tcp --dst-port 22 web-sg
     openstack security group rule create --proto tcp --dst-port 80 web-sg
     openstack security group rule create --proto tcp --dst-port 443 web-sg

     # Listar regras de um security group
     openstack security group rule list web-sg
     
     # Criar load balancer na rede desejada
     openstack loadbalancer create --name web-lb --vip-subnet-id <id_subrede>

     # Adicionar listener (porta de entrada)
     openstack loadbalancer listener create --name web-listener --protocol HTTP --protocol-port 80 --loadbalancer web-lb

     # Criar pool de backend
     openstack loadbalancer pool create --name web-pool --lb-algorithm ROUND_ROBIN --listener web-listener --protocol HTTP

     # Adicionar membros (instâncias) ao pool
     openstack loadbalancer member create --subnet-id <id_subrede> --address 192.168.10.101 --protocol-port 80 web-pool
     openstack loadbalancer member create --subnet-id <id_subrede> --address 192.168.10.102 --protocol-port 80 web-pool

     # Listar todos os load balancers
     openstack loadbalancer list

     # Criar uma porta em uma rede específica
     openstack port create --network <nome_rede> --fixed-ip subnet=<subrede>,ip-address=192.168.100.50 minha-porta

     # Associar uma porta a uma instância
     openstack server add port <id_vm> minha-porta

     # Listar todas as portas da rede
     openstack port list --network <nome_rede>
     ```

3. 🔑**Keystone (Identity)**
   - Serviço de autenticação e autorização centralizado.
   - Gera tokens, define domínios, projetos, usuários e papéis.
   - CLI:

     ```bash
     openstack project create <nome_projeto>
     openstack user create --domain default --password <senha> <nome_usuario>
     openstack role add --project <projeto> --user <usuario> <papel>
     openstack project list
     ```

4. 🖼️**Glance (Image)**
   - Gerencia imagens de disco utilizadas para inicialização de VMs.
   - CLI:

     ```bash
     openstack image create "Ubuntu 22.04" --file ubuntu.qcow2 --disk-format qcow2 --container-format bare --public
     openstack image list
     
     # Detalhar imagem
     openstack image show <id_imagem>
     
     # Criar flavor personalizado
     openstack flavor create m1.custom --id auto --ram 4096 --disk 20 --vcpus 2

     # Marcar flavor para uso restrito (por projeto)
     openstack flavor set --project <id_projeto> m1.custom

     # Listar flavors disponíveis
     openstack flavor list

     # Definir metadados em uma imagem
     openstack image set --property os_distro=ubuntu --property os_version=22.04 <id_imagem>

     # Ver metadados
     openstack image show <id_imagem> -f json | jq '.properties'
     ```

5. 💽**Cinder (Block Storage)**
   - Fornece volumes persistentes para instâncias.
   - CLI:

     ```bash
     openstack volume create --size 10 <nome_volume>
     openstack volume attach <id_vm> <id_volume>
     openstack volume delete <id_volume>
     ```

6. 🧩**Horizon (Dashboard)**
   - Interface web para administração de recursos OpenStack.

7. 📦**Swift (Object Storage)**
   - Armazenamento de objetos escalável.
   - CLI:

     ```bash
     openstack container create <nome_container>
     openstack object upload <nome_container> <arquivo>
     openstack object list <nome_container>
     ```

8. 🌩️**Heat (Orquestração)**
   - Permite orquestrar recursos através de templates YAML.
   - CLI:

     ```bash
     openstack stack create -t template.yaml <nome_stack>
     openstack stack list
     ```

9. 📊**Ceilometer + Gnocchi (Telemetry)**
   - Monitoramento e coleta de métricas.

10. 🧾**Barbican (Secrets Management)**
    - Armazena e gerencia segredos como senhas, chaves e certificados.

11. 🧭**Designate (DNSaaS)**
    - Gerencia zonas e registros DNS.
    - CLI:

      ```bash
      openstack zone create --email admin@dominio.com --type primary --name exemplo.com.
      openstack recordset create <id_zona> --record "192.168.1.10" --type A api.exemplo.com.
      ```

12. 🧪**Magnum (Kubernetes as a Service)**
    - Provisão de clusters Kubernetes ou Docker Swarm.

#### 🔌API

Se preferir consumir de forma mais estruturada, existem SDKs oficiais:

**🧩Python SDK:** openstacksdk, usado em Ansible, Terraform e CLI oficial.

**🧩Go SDK:** gophercloud (mantido pela comunidade).

**🧩Java SDK:** openstack4j.

#### Boas Práticas de Administração

- Utilizar `openstack client` com arquivos RC configurados por projeto.
- Monitorar recursos com ferramentas como Grafana + Ceilometer.
- Auditar logs de componentes via journald ou arquivos em `/var/log/`.
- Automatizar provisionamento com Ansible + OpenStack modules.

OpenStack oferece uma plataforma robusta e extensível, com centenas de configurações possíveis para customização de ambientes altamente escaláveis.

### ☸️Kubernetes

- Plataforma de orquestração de contêineres para automação de implantação, escalonamento e operações de aplicações em contêineres.
- Principais componentes: API Server, Scheduler, etcd, Controller Manager.
- Recursos fundamentais: Pods, Deployments, Services, StatefulSets, ConfigMaps, Secrets.
- Ferramentas adicionais: Helm e Kustomize para configuração e gerenciamento.
- Segurança: RBAC, Network Policies e gestão de Secrets.

### Harbor

- Registro seguro de contêineres para armazenamento e distribuição de imagens Docker.
- Integração nativa com Kubernetes.
- Funcionalidades avançadas como verificação de vulnerabilidades através do Trivy.

## Redes e Segurança

### Redes

- Redes em Kubernetes: Serviços (ClusterIP, NodePort, LoadBalancer), Ingress e CNIs (Calico, Flannel, Cilium).
- Protocolos essenciais: TCP/IP, UDP, HTTP/HTTPS, DNS.
- VPNs e técnicas de balanceamento de carga (NGINX, HAProxy).

### Segurança de Infraestrutura

- Hardening de contêineres: uso de ferramentas como Docker Bench e kube-bench.
- Implementação de Network Policies para segmentação de tráfego.
- Gestão segura e criptografada de Secrets e RBAC para controle de acessos.

## Monitoramento e Observabilidade

### Prometheus

- Monitoramento contínuo e coleta de métricas utilizando exporters.
- PromQL para consultas avançadas e alertas.

### Grafana

- Criação e personalização de dashboards.
- Integração completa com Prometheus para visualização de métricas.

## Mensageria e Comunicação Assíncrona

### Apache Kafka

- Plataforma distribuída para streaming em tempo real de mensagens.
- Principais componentes: Tópicos, Partições, Brokers, Consumidores e Produtores.
- Cenários típicos de uso: integração de dados, processamento em tempo real.

### RabbitMQ

- Broker de mensagens baseado no protocolo AMQP.
- Componentes essenciais: Exchanges, Queues, Bindings.
- Cenários comuns: desacoplamento de serviços, processamento de eventos.

## Linguagens de Programação

### Golang

- Estrutura fundamental da linguagem.
- Módulos (go modules), goroutines, canais, e tratamento de erros.
- Testes unitários com pacote testing.

### Python

- Fundamentos básicos: variáveis, estruturas condicionais, funções.
- Ambiente virtual (venv), bibliotecas comuns (requests, pytest, FastAPI).
- Tratamento de exceções, compreensão de listas e geradores.

### Bash

- Conceitos básicos: variáveis, loops, condicionais.
- Ferramentas avançadas: grep, awk, sed.
- Automação de tarefas no Linux.

## Arquitetura e Desenvolvimento

### Arquitetura Distribuída e Microserviços

- Conceitos essenciais: escalabilidade horizontal/vertical, comunicação assíncrona e síncrona.
- Microserviços: padrões como API Gateway, circuit breaker, service discovery.

### Desenvolvimento de APIs REST

- Estrutura básica e verbos HTTP.
- Tratamento adequado de erros, códigos de status e documentação com Swagger/OpenAPI.

## Sistemas Operacionais

### Linux

- Administração básica: systemctl, journalctl, cron.
- Permissões, gerenciamento de usuários e grupos.
- Otimização e tuning de desempenho (sysctl, ulimit).

## Metodologias Ágeis e Qualidade de Código

### Metodologias Ágeis

- Scrum e Kanban: práticas básicas e reuniões essenciais.

### Revisão e Qualidade de Código

- Importância da revisão de código e boas práticas.
- Testes automatizados (unidade, integração, e2e).
- Refatoração e princípios SOLID.

## Diferenciais Técnicos

### Certificações Kubernetes

- CKA, CKAD, CKS: certificações profissionais reconhecidas.

### Contribuições Open Source

- Participação ativa em projetos abertos.
- Melhores práticas para contribuição: Issues, Pull Requests e revisões técnicas.

### Ícones para Títulos e Subtítulos Técnicos

🔧 Infraestrutura e Orquestração

🧱 OpenStack (geral)
⚙️ Nova (Compute)
🌐 Neutron (Networking)
🔑 Keystone (Identity)
💽 Cinder (Block Storage)
🖼️ Glance (Image)
🌩️ Heat (Orchestration)
🧩 Horizon (Dashboard)
📦 Swift (Object Storage)
🧪 Mistral (Workflows)
📜 Congress (Policy Enforcement)
🔍 Monasca (Monitoring)
📊 Ceilometer/Gnocchi (Telemetry)
🧠 Sahara (Big Data)
🛢️ Trove (Database)
💬 Zaqar (Messaging)
📆 Blazar (Reservation)
🧰 Oslo (Common Libraries)
🧲 Ironic (Bare Metal)
🗂️ Manila (Shared File Systems)
🧪 Magnum (K8s Provisioning)
☁️ Serviços de Nuvem & Containers

🐳 Docker
☸️ Kubernetes
🛡️ Harbor
⚓ Helm

🧬 Kustomize

🔒 Segurança e Identidade

🛡️ RBAC / Policies
🧾 Secrets Management (Barbican)
🧑‍💻 Auth Tokens / Keystone

📡 Comunicação e Mensageria

🛰️ Kafka (Streaming)
🐇 RabbitMQ (Mensageria)
📨 Pub/Sub (Assíncrono)

🧠 Linguagens e Ambientes

🦫 Go (Golang)
🐍 Python
🐚 Bash
🐧 Linux

🧭 Observabilidade

📈 Prometheus
📊 Grafana
🧾 Logs
⏱️ Tracing