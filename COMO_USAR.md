# 🚀 Como Usar o Sistema Distribuído

## 📋 Scripts Disponíveis

### **1. Script Simples (Recomendado)**
```bash
./teste.sh IP1:porta IP2:porta IP3:porta
```

### **2. Script Completo (Com validação IPv4)**
```bash
./teste_completo_ipv4.sh IP1:porta IP2:porta IP3:porta
```

## 🏠 TESTE LOCAL (Múltiplas Instâncias)

### **Executar:**
```bash
./teste.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347
```

### **O que faz:**
- ✅ Compila o projeto
- ✅ Testa versão sequencial
- ✅ Inicia 3 servidores R em portas diferentes
- ✅ Testa sistema distribuído
- ✅ Mostra logs de comunicação

## 🌐 TESTE EM REDE (Máquinas Distintas)

### **Passo 1: Preparar cada máquina**
```bash
# Em cada máquina da rede:
cd ppd-java
javac -d out src/distributed/*.java
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

### **Passo 2: Descobrir IPs**
```bash
# Linux/macOS
ifconfig

# Windows
ipconfig
```

### **Passo 3: Executar teste**
```bash
# Em uma máquina, execute:
./teste.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

## 📊 Exemplos Práticos

### **Exemplo 1: Teste Local**
```bash
./teste.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347
```

### **Exemplo 2: Teste em Rede Doméstica**
```bash
./teste.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

### **Exemplo 3: Teste em Rede Corporativa**
```bash
./teste.sh 172.16.21.50:12345 172.16.21.22:12345 172.16.21.23:12345
```

### **Exemplo 4: Teste com 4 Máquinas**
```bash
./teste.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345 192.168.1.103:12345
```

## 🎯 O que o Script Faz Automaticamente

1. **✅ Compilação** - Compila todo o projeto
2. **✅ Teste Sequencial** - Testa versão sequencial para comparação
3. **✅ Validação IPv4** - Verifica se IPs são válidos
4. **✅ Teste Conectividade** - Testa conexão com cada servidor
5. **✅ Teste Distribuído** - Executa sistema distribuído
6. **✅ Análise Performance** - Compara distribuído vs sequencial
7. **✅ Relatório Final** - Mostra resumo dos testes

## 📋 Logs Esperados

### **Teste Local:**
```
[D] Conectado a 127.0.0.1:12345
[D] Conectado a 127.0.0.1:12346
[D] Conectado a 127.0.0.1:12347
[D] — Rodada EXISTENTE — alvo=XX
[D] Resposta de 127.0.0.1:12345: parcial=X
[D] Resposta de 127.0.0.1:12346: parcial=X
[D] Resposta de 127.0.0.1:12347: parcial=X
[D] TOTAL (EXISTENTE): X ocorrências
```

### **Teste em Rede:**
```
[D] Conectado a 192.168.1.100:12345
[D] Conectado a 192.168.1.101:12345
[D] Conectado a 192.168.1.102:12345
[D] — Rodada EXISTENTE — alvo=XX
[D] Resposta de 192.168.1.100:12345: parcial=X
[D] Resposta de 192.168.1.101:12345: parcial=X
[D] Resposta de 192.168.1.102:12345: parcial=X
[D] TOTAL (EXISTENTE): X ocorrências
```

## 🔧 Solução de Problemas

### **Problema: "Conexão recusada"**
```bash
# Solução: Verificar se servidores R estão rodando
netstat -an | grep 12345
```

### **Problema: "IPv4 inválido"**
```bash
# Solução: Usar formato correto
./teste.sh 192.168.1.100:12345 192.168.1.101:12345
```

### **Problema: "Falha na compilação"**
```bash
# Solução: Verificar se está no diretório correto
cd /Users/rmartins/Desktop/maligno/ppd-java
```

## 🎉 Resultado Esperado

**✅ SUCESSO:** Todos os testes passam, sistema funcionando perfeitamente!

**📝 Logs mostram:**
- ✅ Compilação bem-sucedida
- ✅ Versão sequencial funcionando
- ✅ Conexões com servidores R estabelecidas
- ✅ Contagem distribuída executada
- ✅ Resultados corretos (número existente + inexistente)
- ✅ Performance medida e comparada

## 🚀 Próximos Passos

1. **✅ Execute teste local:** `./teste.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347`
2. **✅ Configure máquinas na rede**
3. **✅ Execute teste em rede:** `./teste.sh IP1:12345 IP2:12345 IP3:12345`
4. **✅ Demonstre ao professor**

**🎯 Sistema pronto para entrega e demonstração!**
