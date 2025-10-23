# 🚀 Scripts Essenciais - Sistema Distribuído

## 📋 Scripts Mantidos (Essenciais)

### **1. `teste_automatico.sh` - ⭐ PRINCIPAL**
```bash
./teste_automatico.sh IP1:porta IP2:porta IP3:porta
```
**✅ RECOMENDADO** - Inicia servidores automaticamente e executa todos os testes

### **2. `teste.sh` - ⚡ Simples**
```bash
./teste.sh IP1:porta IP2:porta IP3:porta
```
**✅ Básico** - Teste rápido (requer servidores R já rodando)

### **3. `teste_automatico.bat` - 🪟 Windows**
```cmd
teste_automatico.bat IP1:porta IP2:porta IP3:porta
```
**✅ Windows** - Versão para usuários Windows

## 📖 Documentação Mantida

### **1. `README.md` - 📚 Principal**
Documentação completa do sistema

### **2. `COMO_USAR.md` - 🎯 Guia de Uso**
Instruções simples de como usar os scripts

### **3. `COMO_TESTAR.md` - 🧪 Guia de Testes**
Instruções detalhadas para testes

### **4. `GUIA_TESTE_REDE.md` - 🌐 Teste em Rede**
Guia específico para teste em rede local

## 🗑️ Scripts Removidos (Desnecessários)

- ❌ `demo.sh` - Substituído por `teste_automatico.sh`
- ❌ `demonstracao_logs.sh` - Funcionalidade integrada
- ❌ `teste_local_multiplas_instancias.sh` - Substituído por `teste_automatico.sh`
- ❌ `teste_maquinas_distintas.sh` - Substituído por `teste_automatico.sh`
- ❌ `teste_rapido.sh` - Substituído por `teste.sh`
- ❌ `teste_rede.sh` - Substituído por `teste_automatico.sh`
- ❌ `teste_rede.bat` - Substituído por `teste_automatico.bat`
- ❌ `validar_ipv4.sh` - Funcionalidade integrada
- ❌ `teste_completo_ipv4.sh` - Substituído por `teste_automatico.sh`

## 🎯 Como Usar (Resumo)

### **Para Teste Local:**
```bash
./teste_automatico.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347
```

### **Para Teste em Rede:**
```bash
# Em cada máquina da rede:
java -cp out distributed.ReceptorServer 0.0.0.0 12345

# Em uma máquina:
./teste_automatico.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

### **Para Windows:**
```cmd
teste_automatico.bat 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

## ✅ Resultado da Limpeza

**Scripts mantidos:** 3 essenciais
**Documentação mantida:** 4 arquivos
**Scripts removidos:** 9 desnecessários

**🎉 Projeto limpo e organizado com apenas o essencial!**
