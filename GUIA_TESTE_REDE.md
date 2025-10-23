# 🌐 Guia Completo para Teste em Rede Local

## 📋 Seguindo as Sugestões do Documento

O documento sugere dois tipos de teste:
1. **Teste local**: Múltiplas instâncias R em portas diferentes
2. **Teste em rede**: Máquinas distintas na mesma rede local

## 🏠 TESTE 1: Múltiplas Instâncias Locais

### **Executar:**
```bash
./teste_local_multiplas_instancias.sh
```

### **O que faz:**
- ✅ Inicia 4 servidores R em portas diferentes (12345, 12346, 12347, 12348)
- ✅ Testa sistema distribuído com múltiplas instâncias
- ✅ Demonstra logs de comunicação local

### **Logs esperados:**
```
[D] Conectado a localhost:12345
[D] Conectado a localhost:12346
[D] Conectado a localhost:12347
[D] Conectado a localhost:12348
[D] — Rodada EXISTENTE — alvo=XX
[D] Resposta de localhost:12345: parcial=X
[D] Resposta de localhost:12346: parcial=X
[D] Resposta de localhost:12347: parcial=X
[D] Resposta de localhost:12348: parcial=X
[D] TOTAL (EXISTENTE): X ocorrências
```

## 🌐 TESTE 2: Máquinas Distintas na Rede Local

### **Preparação - Em cada máquina da rede:**

#### **1. Copiar projeto:**
```bash
# Copie o projeto para cada máquina
scp -r ppd-java/ usuario@192.168.1.100:/home/usuario/
scp -r ppd-java/ usuario@192.168.1.101:/home/usuario/
scp -r ppd-java/ usuario@192.168.1.102:/home/usuario/
```

#### **2. Compilar em cada máquina:**
```bash
cd ppd-java
javac -d out src/distributed/*.java
```

#### **3. Descobrir IP de cada máquina:**
```bash
# Linux/macOS
ifconfig

# Windows
ipconfig
```

**Anote os IPs:**
- Máquina 1: `192.168.1.100`
- Máquina 2: `192.168.1.101`
- Máquina 3: `192.168.1.102`
- Máquina 4: `192.168.1.103`

#### **4. Executar ReceptorServer em cada máquina:**
```bash
# Em cada máquina, execute:
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

### **Executar teste em rede:**
```bash
# Em uma máquina, execute:
./teste_maquinas_distintas.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345 192.168.1.103:12345
```

### **Logs esperados com IPs reais:**
```
[D] Conectado a 192.168.1.100:12345
[D] Conectado a 192.168.1.101:12345
[D] Conectado a 192.168.1.102:12345
[D] Conectado a 192.168.1.103:12345
[D] — Rodada EXISTENTE — alvo=XX
[D] Resposta de 192.168.1.100:12345: parcial=X
[D] Resposta de 192.168.1.101:12345: parcial=X
[D] Resposta de 192.168.1.102:12345: parcial=X
[D] Resposta de 192.168.1.103:12345: parcial=X
[D] TOTAL (EXISTENTE): X ocorrências
```

## 📊 Demonstração de Logs

### **Executar:**
```bash
./demonstracao_logs.sh
```

### **Demonstra os logs mencionados no documento:**
- ✅ `[R] Pedido recebido do cliente 172.16.21.50`
- ✅ `[D] Enviando Pedido para 172.16.21.22...`
- ✅ `[D] Resposta recebida: número não encontrado`

## 🔧 Scripts Disponíveis

| Script | Uso | Descrição |
|--------|-----|-----------|
| `teste_local_multiplas_instancias.sh` | 🏠 **Teste Local** | Múltiplas instâncias R em portas diferentes |
| `teste_maquinas_distintas.sh` | 🌐 **Teste Rede** | Máquinas distintas na rede local |
| `demonstracao_logs.sh` | 📋 **Demonstração** | Mostra logs mencionados no documento |

## 🎯 Exemplo Completo de Teste em Rede

### **Cenário: 4 computadores na rede local**

#### **Computador 1 (192.168.1.100):**
```bash
cd ppd-java
javac -d out src/distributed/*.java
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

#### **Computador 2 (192.168.1.101):**
```bash
cd ppd-java
javac -d out src/distributed/*.java
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

#### **Computador 3 (192.168.1.102):**
```bash
cd ppd-java
javac -d out src/distributed/*.java
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

#### **Computador 4 (192.168.1.103) - Executa Distribuidor:**
```bash
cd ppd-java
javac -d out src/distributed/*.java
java -cp out distributed.Distribuidor 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345 --tam 1000000 --missing
```

### **Logs esperados:**
```
[D] 2025-10-23 10:30:00 — Vetor gerado: 1000000 elementos; alvo escolhido (pos=523543) = 78
[D] 2025-10-23 10:30:00 — Conectado a 192.168.1.100:12345
[D] 2025-10-23 10:30:00 — Conectado a 192.168.1.101:12345
[D] 2025-10-23 10:30:00 — Conectado a 192.168.1.102:12345
[D] 2025-10-23 10:30:00 — — Rodada EXISTENTE — alvo=78
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.100:12345: parcial=1719
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.101:12345: parcial=1676
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.102:12345: parcial=1676
[D] 2025-10-23 10:30:01 — TOTAL (EXISTENTE): 5071 ocorrências. Tempo distribuído: 61,84 ms
[D] 2025-10-23 10:30:01 — Tempo sequencial local: 2,14 ms (resultado=5071)
[D] 2025-10-23 10:30:01 — — Rodada INEXISTENTE — alvo=111
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.100:12345: parcial=0
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.101:12345: parcial=0
[D] 2025-10-23 10:30:01 — Resposta de 192.168.1.102:12345: parcial=0
[D] 2025-10-23 10:30:01 — TOTAL (INEXISTENTE): 0 ocorrências. Tempo distribuído: 41,27 ms
[D] 2025-10-23 10:30:01 — Tempo sequencial local: 3,23 ms (resultado=0)
[D] 2025-10-23 10:30:01 — Conexão fechada: 192.168.1.100:12345
[D] 2025-10-23 10:30:01 — Conexão fechada: 192.168.1.101:12345
[D] 2025-10-23 10:30:01 — Conexão fechada: 192.168.1.102:12345
[D] 2025-10-23 10:30:01 — Encerramento enviado para todos os R e conexões fechadas.
```

## 🚀 Próximos Passos

1. **✅ Execute teste local primeiro:** `./teste_local_multiplas_instancias.sh`
2. **✅ Execute demonstração de logs:** `./demonstracao_logs.sh`
3. **✅ Configure máquinas na rede local**
4. **✅ Execute teste em rede:** `./teste_maquinas_distintas.sh IP1:12345 IP2:12345 IP3:12345`

## 🎯 Resultado Esperado

**✅ SUCESSO:** Sistema funcionando em rede local com logs mostrando comunicação entre IPs diferentes!

**📝 Logs mostram exatamente o que o documento pede:**
- `[R] Pedido recebido do cliente 192.168.1.XXX:XXXXX`
- `[D] Enviando Pedido para 192.168.1.XXX:12345...`
- `[D] Resposta recebida: número encontrado/não encontrado`

**🎉 Sistema pronto para demonstração ao professor!**
