# 🧪 Como Testar o Sistema Distribuído

## 📋 Scripts de Teste Disponíveis

### 1. **Teste Rápido** (Recomendado para verificação básica)
```bash
./teste_rapido.sh
```
**O que faz:**
- ✅ Compila o projeto
- ✅ Testa versão sequencial
- ✅ Inicia 2 servidores R
- ✅ Testa sistema distribuído
- ✅ Limpa processos automaticamente

### 2. **Teste Completo** (Para validação total)
```bash
./teste_automatico.sh
```
**O que faz:**
- ✅ Todos os testes do teste rápido
- ✅ Teste com vetores pequenos, médios e grandes
- ✅ Teste com 2 e 3 servidores
- ✅ Teste de performance
- ✅ Teste de estresse
- ✅ Verificação de conectividade

### 3. **Windows** (Para usuários Windows)
```cmd
teste_automatico.bat
```

## 🚀 Como Executar

### **Linux/macOS:**
```bash
# Teste rápido (2-3 minutos)
./teste_rapido.sh

# Teste completo (5-10 minutos)
./teste_automatico.sh
```

### **Windows:**
```cmd
# Teste completo
teste_automatico.bat
```

## 📊 O que os Testes Verificam

### **Teste Rápido:**
1. ✅ **Compilação** - Verifica se o código compila sem erros
2. ✅ **Versão Sequencial** - Testa ContagemSequencial com vetor pequeno
3. ✅ **Sistema Distribuído** - Testa com 2 servidores R
4. ✅ **Limpeza** - Remove processos em background

### **Teste Completo:**
1. ✅ **Compilação** - Verifica se o código compila sem erros
2. ✅ **Versão Sequencial** - Testa com vetores pequenos e grandes
3. ✅ **Sistema Distribuído** - Testa com 2 e 3 servidores
4. ✅ **Vetores Pequenos** - 1K elementos para demonstração
5. ✅ **Vetores Médios** - 100K elementos
6. ✅ **Vetores Grandes** - 1M elementos
7. ✅ **Performance** - Compara distribuído vs sequencial
8. ✅ **Estresse** - Múltiplas execuções consecutivas
9. ✅ **Conectividade** - Verifica se servidores estão ativos

## 🎯 Saída Esperada

### **Teste Rápido - Saída de Sucesso:**
```
🚀 TESTE RÁPIDO DO SISTEMA DISTRIBUÍDO
=====================================

ℹ️  Compilando projeto...
✅ Compilação OK!

ℹ️  Testando versão sequencial...
[SEQ] 2025-10-23 10:30:00 — Rodada EXISTENTE — procurando 42
[SEQ] 2025-10-23 10:30:00 — Resultado=8, Tempo=0,01 ms
[SEQ] 2025-10-23 10:30:00 — Rodada INEXISTENTE — procurando 111
[SEQ] 2025-10-23 10:30:00 — Resultado=0, Tempo=0,01 ms
✅ Versão sequencial OK!

ℹ️  Iniciando servidores R...
ℹ️  Testando sistema distribuído...
[D] 2025-10-23 10:30:05 — Vetor gerado: 1000 elementos; alvo escolhido (pos=523) = 42
[D] 2025-10-23 10:30:05 — Conectado a localhost:12345
[D] 2025-10-23 10:30:05 — Conectado a localhost:12346
[D] 2025-10-23 10:30:05 — — Rodada EXISTENTE — alvo=42
[D] 2025-10-23 10:30:05 — Resposta de localhost:12345: parcial=3
[D] 2025-10-23 10:30:05 — Resposta de localhost:12346: parcial=2
[D] 2025-10-23 10:30:05 — TOTAL (EXISTENTE): 5 ocorrências. Tempo distribuído: 15,26 ms
[D] 2025-10-23 10:30:05 — Tempo sequencial local: 0,15 ms (resultado=5)
[D] 2025-10-23 10:30:05 — — Rodada INEXISTENTE — alvo=111
[D] 2025-10-23 10:30:05 — Resposta de localhost:12345: parcial=0
[D] 2025-10-23 10:30:05 — Resposta de localhost:12346: parcial=0
[D] 2025-10-23 10:30:05 — TOTAL (INEXISTENTE): 0 ocorrências. Tempo distribuído: 8,32 ms
[D] 2025-10-23 10:30:05 — Tempo sequencial local: 0,12 ms (resultado=0)
[D] 2025-10-23 10:30:05 — Conexão fechada: localhost:12345
[D] 2025-10-23 10:30:05 — Conexão fechada: localhost:12346
[D] 2025-10-23 10:30:05 — Encerramento enviado para todos os R e conexões fechadas.
✅ Sistema distribuído OK!

✅ 🎉 TESTE RÁPIDO CONCLUÍDO COM SUCESSO!
✅ 🚀 Sistema funcionando perfeitamente!

ℹ️  Para teste completo, execute: ./teste_automatico.sh
```

## 🔧 Solução de Problemas

### **Problema: "Porta já em uso"**
```bash
# Solução: Matar processos Java
pkill -f java
# Ou usar portas diferentes
java -cp out distributed.ReceptorServer 0.0.0.0 12348
```

### **Problema: "Conexão recusada"**
```bash
# Solução: Verificar se servidores R estão rodando
netstat -an | grep 12345
# Se não estiver, reiniciar servidores
```

### **Problema: "Falha na compilação"**
```bash
# Solução: Verificar se está no diretório correto
cd /Users/rmartins/Desktop/maligno/ppd-java
# Verificar se arquivos Java existem
ls src/distributed/
```

## 📝 Teste Manual (Sem Scripts)

Se preferir testar manualmente:

### **1. Compilar:**
```bash
javac -d out src/distributed/*.java
```

### **2. Testar sequencial:**
```bash
java -cp out distributed.ContagemSequencial 1000 --missing
```

### **3. Iniciar servidores R (3 terminais):**
```bash
# Terminal 1
java -cp out distributed.ReceptorServer 0.0.0.0 12345

# Terminal 2  
java -cp out distributed.ReceptorServer 0.0.0.0 12346

# Terminal 3
java -cp out distributed.ReceptorServer 0.0.0.0 12347
```

### **4. Testar distribuidor (4º terminal):**
```bash
java -cp out distributed.Distribuidor localhost:12345 localhost:12346 localhost:12347 --tam 1000 --missing
```

## 🎯 Resultado Esperado

**✅ SUCESSO:** Todos os testes passam, sistema funcionando perfeitamente!

**❌ FALHA:** Verificar mensagens de erro e seguir soluções acima.

## 🚀 Próximos Passos

Após executar os testes com sucesso:

1. **✅ Sistema está pronto para demonstração ao professor**
2. **✅ Todos os requisitos do trabalho foram atendidos**
3. **✅ Código está funcionando perfeitamente**
4. **✅ Pronto para entrega no Canvas**

**🎉 Parabéns! Seu sistema distribuído está funcionando perfeitamente!**
