# 🌐 Guia Rápido - Teste em Ambiente Real

## 🚀 **Como Testar em Múltiplas Máquinas**

### **Passo 1: Preparar cada máquina da rede**

Em **CADA máquina** da rede local, execute:

```bash
# 1. Copiar projeto para a máquina
scp -r ppd-java/ usuario@IP_DA_MAQUINA:/home/usuario/

# 2. Acessar a máquina
ssh usuario@IP_DA_MAQUINA

# 3. Executar script de preparação
cd ppd-java
./preparar_maquina.sh
```

### **Passo 2: Executar teste distribuído**

Em **UMA máquina** (coordenadora), execute:

```bash
# Teste com IPs reais das outras máquinas
./teste_rede_real.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

## 📋 **Scripts Disponíveis**

| Script | Uso | Descrição |
|--------|-----|-----------|
| **`preparar_maquina.sh`** | 🔧 **Preparação** | Execute em cada máquina da rede |
| **`teste_rede_real.sh`** | 🌐 **Teste** | Execute na máquina coordenadora |
| **`teste_automatico.sh`** | 🏠 **Local** | Para teste local com múltiplas instâncias |

## 🎯 **Exemplo Completo**

### **Cenário: 4 computadores na rede local**

#### **Computador 1 (192.168.1.100):**
```bash
cd ppd-java
./preparar_maquina.sh
# Logs: [R] Servidor R ouvindo em 0.0.0.0:12345
```

#### **Computador 2 (192.168.1.101):**
```bash
cd ppd-java
./preparar_maquina.sh
# Logs: [R] Servidor R ouvindo em 0.0.0.0:12345
```

#### **Computador 3 (192.168.1.102):**
```bash
cd ppd-java
./preparar_maquina.sh
# Logs: [R] Servidor R ouvindo em 0.0.0.0:12345
```

#### **Computador 4 (192.168.1.103) - Coordenador:**
```bash
cd ppd-java
./teste_rede_real.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

## 📊 **Logs Esperados em Ambiente Real**

### **Logs do Distribuidor (Máquina Coordenadora):**
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
```

### **Logs dos Servidores R (Outras Máquinas):**
```
[R] 2025-10-23 10:30:00 — Servidor R ouvindo em 0.0.0.0:12345
[R] 2025-10-23 10:30:00 — Conexão aceita de /192.168.1.103:50406
[R] 2025-10-23 10:30:00 — Pedido recebido de /192.168.1.103:50406 — procurando: 78, tamanho: 333334
[R] 2025-10-23 10:30:01 — Pedido recebido de /192.168.1.103:50406 — procurando: 111, tamanho: 333334
[R] 2025-10-23 10:30:01 — Encerramento recebido de /192.168.1.103:50406
[R] 2025-10-23 10:30:01 — Conexão encerrada: /192.168.1.103:50406
```

## 🔧 **Solução de Problemas**

### **Problema: "Connection refused"**
```bash
# Verificar se servidores estão rodando
netstat -an | grep 12345

# Verificar conectividade
ping 192.168.1.100
telnet 192.168.1.100 12345
```

### **Problema: "Falha na compilação"**
```bash
# Verificar se está no diretório correto
cd /Users/rmartins/Desktop/maligno/ppd-java
ls src/distributed/
```

### **Problema: "Porta já em uso"**
```bash
# Liberar porta
pkill -f "distributed.ReceptorServer"
```

## ✅ **Vantagens do Teste em Ambiente Real**

- ✅ **Comunicação real entre máquinas** - Logs mostram IPs diferentes
- ✅ **Teste de rede local** - Simula ambiente de produção
- ✅ **Distribuição real** - Trabalho dividido entre máquinas físicas
- ✅ **Demonstração ao professor** - Mostra sistema funcionando em rede
- ✅ **Logs autênticos** - Exatamente como especificado no documento

## 🎯 **Resultado Esperado**

**✅ SUCESSO:** Sistema funcionando em rede local com logs mostrando comunicação entre IPs diferentes!

**📝 Logs mostram exatamente o que o documento pede:**
- `[R] Pedido recebido do cliente 192.168.1.XXX:XXXXX`
- `[D] Conectado a 192.168.1.XXX:12345`
- `[D] Resposta de 192.168.1.XXX:12345: parcial=X`

**🎉 Sistema pronto para demonstração ao professor!**
