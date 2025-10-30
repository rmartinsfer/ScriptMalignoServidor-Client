# Sistema Distribuído de Contagem Sequencial - ESTRUTURA SEPARADA

## 📋 Visão Geral

Este projeto implementa um **sistema distribuído** para contagem de elementos em vetores grandes, com **cliente e servidor fisicamente separados** para execução em máquinas diferentes. Demonstra conceitos de **programação paralela e distribuída** em Java.

## 🏗️ Estrutura do Projeto

```
ppd-java/
├── shared/                    # Classes compartilhadas
│   └── src/distributed/
│       ├── Comunicado.java
│       ├── ComunicadoEncerramento.java
│       ├── Pedido.java
│       ├── Resposta.java
│       └── Log.java
├── cliente/                   # Código do CLIENTE
│   ├── src/distributed/
│   │   ├── Distribuidor.java
│   │   └── ContagemSequencial.java
│   ├── compilar.sh
│   └── out/                   # Classes compiladas
├── servidor/                  # Código do SERVIDOR
│   ├── src/distributed/
│   │   └── ReceptorServer.java
│   ├── compilar.sh
│   └── out/                   # Classes compiladas
└── teste_distribuido.sh       # Script de teste completo
```

## 🖥️ **CLIENTE** - Máquina 1

### **Responsabilidades:**
- ✅ Gera vetor aleatório de tamanho configurável
- ✅ Conecta com múltiplos servidores em máquinas diferentes
- ✅ Divide o vetor em blocos iguais para cada servidor
- ✅ Envia blocos para servidores em paralelo
- ✅ Coleta e soma resultados parciais de todos os servidores
- ✅ Compara performance: distribuído vs sequencial

### **Classes do Cliente:**
- **`Distribuidor.java`** - Cliente principal que coordena tudo
- **`ContagemSequencial.java`** - Versão sequencial para comparação

### **Como Compilar o Cliente:**
```bash
cd cliente/
./compilar.sh
```

### **Como Executar o Cliente:**
```bash
# Conectar a servidores em máquinas diferentes
java -cp out distributed.Distribuidor 192.168.1.100:12345 192.168.1.101:12346 192.168.1.102:12347 --tam 1000000 --missing

# Teste sequencial local
java -cp out distributed.ContagemSequencial 1000000 --missing
```

---

## 🖥️ **SERVIDOR** - Máquinas 2, 3, 4...

### **Responsabilidades:**
- ✅ Fica aguardando conexões de clientes
- ✅ Aceita múltiplas conexões simultâneas
- ✅ Recebe pedidos de processamento (`Pedido`)
- ✅ Processa contagem em paralelo usando threads
- ✅ Retorna resultados via rede (`Resposta`)
- ✅ Gerencia encerramento de conexões

### **Classes do Servidor:**
- **`ReceptorServer.java`** - Servidor principal que processa pedidos

### **Como Compilar o Servidor:**
```bash
cd servidor/
./compilar.sh
```

### **Como Executar o Servidor:**
```bash
# Em cada máquina servidor
java -cp out distributed.ReceptorServer 0.0.0.0 12345

# Ou especificando IP e porta
java -cp out distributed.ReceptorServer 192.168.1.100 12345
```

---

## 📦 **CLASSES COMPARTILHADAS**

### **Localização:** `shared/src/distributed/`

- **`Comunicado.java`** - Classe base para comunicação
- **`ComunicadoEncerramento.java`** - Sinaliza encerramento
- **`Pedido.java`** - Contém vetor e número a procurar
- **`Resposta.java`** - Retorna resultado da contagem
- **`Log.java`** - Sistema de logging

---

## 🚀 **Cenários de Execução**

### **Cenário 1: Teste Local (Tudo na mesma máquina)**
```bash
# Terminal 1 - Servidor 1
java -cp servidor/out distributed.ReceptorServer 0.0.0.0 12345

# Terminal 2 - Servidor 2  
java -cp servidor/out distributed.ReceptorServer 0.0.0.0 12346

# Terminal 3 - Cliente
java -cp cliente/out distributed.Distribuidor 127.0.0.1:12345 127.0.0.1:12346 --tam 1000000
```

### **Cenário 2: Distribuído Real (Máquinas diferentes)**

**Máquina 1 (IP: 192.168.1.100) - Servidor:**
```bash
java -cp servidor/out distributed.ReceptorServer 0.0.0.0 12345
```

**Máquina 2 (IP: 192.168.1.101) - Servidor:**
```bash
java -cp servidor/out distributed.ReceptorServer 0.0.0.0 12346
```

**Máquina 3 (IP: 192.168.1.102) - Cliente:**
```bash
java -cp cliente/out distributed.Distribuidor 192.168.1.100:12345 192.168.1.101:12346 --tam 1000000 --missing
```

### **Cenário 3: Teste Automatizado**
```bash
./teste_distribuido.sh
```

---

## 🔄 **Fluxo de Comunicação**

```
CLIENTE (Máquina 3)              SERVIDORES (Máquinas 1,2)
     ↓                              ↓
1. Gera vetor[1M]              1. Aguardam conexões
     ↓                              ↓
2. Divide em blocos            2. Aceitam conexões
     ↓                              ↓
3. Envia Pedido(bloco, alvo)   3. Recebem Pedidos
     ↓                              ↓
4. Aguarda Respostas           4. Processam p.contar()
     ↓                              ↓
5. Recebe Respostas(contagem)  5. Enviam Respostas
     ↓                              ↓
6. Soma resultados             6. Aguardam próximos pedidos
     ↓                              ↓
7. Envia Encerramento          7. Encerram conexões
```

---

## 📊 **Vantagens da Estrutura Separada**

### **1. Distribuição Real**
- Cliente e servidores em máquinas diferentes
- Demonstra comunicação de rede real
- Simula ambiente de produção

### **2. Escalabilidade**
- Fácil adicionar mais servidores
- Cada servidor pode estar em máquina diferente
- Balanceamento de carga real

### **3. Desenvolvimento Independente**
- Cliente e servidor podem ser desenvolvidos separadamente
- Facilita manutenção e atualizações
- Testes isolados de cada componente

### **4. Reutilização**
- Servidor pode atender múltiplos clientes
- Classes compartilhadas evitam duplicação
- Protocolo padronizado

---

## 🛠️ **Comandos Úteis**

### **Compilar Tudo:**
```bash
# Compilar classes compartilhadas
javac -d shared/out shared/src/distributed/*.java

# Compilar cliente
javac -cp shared/out -d cliente/out cliente/src/distributed/*.java

# Compilar servidor
javac -cp shared/out -d servidor/out servidor/src/distributed/*.java
```

### **Executar Teste Completo:**
```bash
chmod +x teste_distribuido.sh
./teste_distribuido.sh
```

### **Verificar Conexões de Rede:**
```bash
# Verificar se servidor está ouvindo
netstat -an | grep 12345

# Testar conectividade
telnet 192.168.1.100 12345
```

---

## 📝 **Logs e Debugging**

### **Tags de Log:**
- **`[D]`** - Distribuidor (Cliente)
- **`[R]`** - ReceptorServer (Servidor)
- **`[SEQ]`** - ContagemSequencial

### **Exemplo de Log:**
```
[D] 2024-01-15 10:30:15 — Vetor gerado: 1000000 elementos; alvo escolhido (pos=123456) = 42
[R] 2024-01-15 10:30:16 — Pedido recebido de /192.168.1.102:54321 — procurando: 42, tamanho: 500000
[D] 2024-01-15 10:30:17 — TOTAL (EXISTENTE): 1000 ocorrências. Tempo distribuído: 45.67 ms
```

---

## 🎯 **Objetivos do Exercício**

1. **Compreender** arquiteturas cliente-servidor distribuídas
2. **Implementar** comunicação de rede entre máquinas diferentes
3. **Aplicar** conceitos de programação paralela e distribuída
4. **Medir** performance em ambiente distribuído real
5. **Gerenciar** recursos de rede e concorrência

Esta estrutura separada permite executar o sistema em máquinas diferentes, demonstrando verdadeiramente os conceitos de programação distribuída! 🚀
