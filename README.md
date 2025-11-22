# Projeto-Integrado-Modelagem-de-Dados

#Esse projeto visa a construção de um sistema de monitoramento de energia utilizando um sensor de corrente alternada

#Este sistema coleta dados de um sensor de corrente elétrica (SCT-013) conectado a um ESP32, armazena no Firebase Realtime Database, processa via Dart e insere no MySQL para análise no Power BI

# Arquitetura do projeto:

#ESP32 + SCT-013  →  Firebase  →  Dart App  →  MySQL  →  Power BI
#(Coleta)         (Realtime)   (Processa)  (Armazena) (Visualiza)

# Tecnologias Utilizadas: 

#Linguagem: Dart 3.9.4 (dependencies de http1.1.0 e mysql_client0.0.27

#Banco de Dados: MySQL 8.0

#Cloud: Firebase Realtime Database

#Hardware: ESP32 + Sensor SCT-013

#Visualização: Power BI dashboard + medidas DAX

# EXECUTANDO..

#Pré-requisitos:

#Dart SDK instalado

#MySQL Server rodando

#Conta Firebase configurada

#ESP32 com sensor SCT-013 (opcional, pode-se usar dados ficticios)

# Principais problemas ao executar e possíveis soluções:

#❌ Erro: "Can't connect to MySQL server"
#Verifique se o MySQL está rodando
#Confirme usuário e senha em config.dart

#❌ Erro: "Cannot add or update a child row"
#Você tentou cadastrar máquina sem operador existente
#Ou sensor sem máquina existente
#Siga a ordem: Operário → Máquina → Sensor

#❌ Erro: "Firebase returns null"
#Verifique a URL do Firebase

#Projeto desenvolvido para fins acadêmicos.
