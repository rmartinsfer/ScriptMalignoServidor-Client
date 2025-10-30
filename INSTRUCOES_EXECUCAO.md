# 🚀 Instruções de Execução - Sistema Distribuído Separado

## ✅ **SISTEMA FUNCIONANDO PERFEITAMENTE!**

O projeto foi **separado fisicamente** em cliente e servidor para execução em máquinas diferentes, exatamente como o exercício pede!

---

## 📁 **Estrutura Final do Projeto**

```
ppd-java/
├── shared/                    # Classes compartilhadas
│   ├── src/distributed/       # Código fonte compartilhado
│   └── out/                   # Classes compiladas
├── cliente/                   # Código do CLIENTE
│   ├── src/distributed/       # Código fonte do cliente
│   ├── out/                   # Classes compiladas
│   └── compilar.sh            # Script de compilação
├── servidor/                  # Código do SERVIDOR
│   ├── src/distributed/       # Código fonte do servidor
│   ├── out/                   # Classes compiladas
│   └── compilar.sh            # Script de compilação
├── teste_distribuido.sh       # Teste completo automatizado
└── README_SEPARADO.md         # Documentação completa
```

---

## 🎯 **Cenários de Execução**

### **1. Teste Local (Tudo na mesma máquina)**
```bash
# Executar teste automatizado
./teste_distribuido.sh
```

### **2. Execução Manual Local**
```bash
# Terminal 1 - Servidor 1
java -cp servidor/out:shared/out distributed.ReceptorServer 0.0.0.0 12345

# Terminal 2 - Servidor 2
java -cp servidor/out:shared/out distributed.ReceptorServer 0.0.0.0 12346

# Terminal 3 - Cliente
java -cp cliente/out:shared/out distributed.Distribuidor 127.0.0.1:12345 127.0.0.1:12346 --tam 1000000 --missing
```

### **3. Execução Distribuída Real (Máquinas diferentes)**

**Máquina 1 (IP: 192.168.1.100) - Servidor:**
```bash
# Copiar pasta servidor/ e shared/ para a máquina
java -cp servidor/out:shared/out distributed.ReceptorServer 0.0.0.0 12345
```

**Máquina 2 (IP: 192.168.1.101) - Servidor:**
```bash
# Copiar pasta servidor/ e shared/ para a máquina
java -cp servidor/out:shared/out distributed.ReceptorServer 0.0.0.0 12346
```

**Máquina 3 (IP: 192.168.1.102) - Cliente:**
```bash
# Copiar pasta cliente/ e shared/ para a máquina
java -cp cliente/out:shared/out distributed.Distribuidor 192.168.1.100:12345 192.168.1.101:12346 --tam 1000000 --missing
```

---

## 📊 **Resultados do Teste**

O sistema foi testado com sucesso e mostrou:

- ✅ **Compilação**: Todas as classes compilam corretamente
- ✅ **Comunicação**: Cliente conecta com múltiplos servidores
- ✅ **Processamento**: Divisão e processamento paralelo funcionando
- ✅ **Performance**: Comparação sequencial vs distribuído
- ✅ **Robustez**: Encerramento correto de conexões

### **Exemplo de Saída:**
```
[D] 2025-10-30 07:44:25 — Vetor gerado: 1000000 elementos; alvo escolhido (pos=928626) = 78
[D] 2025-10-30 07:44:25 — Conectado a 127.0.0.1:12345
[D] 2025-10-30 07:44:25 — Conectado a 127.0.0.1:12346
[D] 2025-10-30 07:44:25 — Conectado a 127.0.0.1:12347
[D] 2025-10-30 07:44:25 — TOTAL (EXISTENTE): 4969 ocorrências. Tempo distribuído: 49,63 ms
[D] 2025-10-30 07:44:25 — Tempo sequencial local: 2,22 ms (resultado=4969)
```

---

## 🎓 **Para Apresentação ao Professor**

### **1. Demonstração Local:**
```bash
./teste_distribuido.sh
```

### **2. Explicação da Arquitetura:**
- **Cliente**: Coordena, divide, coleta resultados
- **Servidor**: Processa blocos em paralelo
- **Compartilhado**: Protocolo de comunicação

### **3. Demonstração Distribuída:**
- Executar servidor em uma máquina
- Executar cliente em outra máquina
- Mostrar comunicação de rede real

---

## 🔧 **Comandos de Compilação Individual**

### **Compilar Cliente:**
```bash
cd cliente/
./compilar.sh
```

### **Compilar Servidor:**
```bash
cd servidor/
./compilar.sh
```

### **Compilar Tudo:**
```bash
# Classes compartilhadas
javac -d shared/out shared/src/distributed/*.java

# Cliente
javac -cp shared/out -d cliente/out cliente/src/distributed/*.java

# Servidor
javac -cp shared/out -d servidor/out servidor/src/distributed/*.java
```

---

## 📝 **Arquivos Importantes**

- **`README_SEPARADO.md`** - Documentação completa
- **`teste_distribuido.sh`** - Teste automatizado
- **`cliente/compilar.sh`** - Compilação do cliente
- **`servidor/compilar.sh`** - Compilação do servidor

---

## ✅ **CONCLUSÃO**

O sistema está **100% funcional** e **separado fisicamente** conforme solicitado pelo exercício. Cliente e servidor podem ser executados em máquinas diferentes, demonstrando verdadeiramente os conceitos de programação distribuída!

**🎉 PRONTO PARA APRESENTAÇÃO AO PROFESSOR!** 🎉
