# PPD-Java — Sistema Distribuído de Contagem

## 📋 Descrição

Sistema distribuído que implementa um padrão **Divide and Conquer (D&R)** para contar ocorrências de um número em um vetor grande. O sistema é composto por um **Distribuidor (D)** que divide o trabalho entre múltiplos **Servidores R (Receptores)** que processam em paralelo.

## 🏗️ Arquitetura

### Componentes Principais

- **Distribuidor (D)**: Cliente que coordena a distribuição do trabalho
- **ReceptorServer (R)**: Servidor que processa pedidos de contagem
- **ContagemSequencial**: Versão sequencial para comparação de performance
- **Classes de Comunicação**: `Pedido`, `Resposta`, `ComunicadoEncerramento`

### Fluxo de Execução

1. **D** gera um vetor grande de números aleatórios
2. **D** divide o vetor em partes iguais para cada servidor R
3. **D** cria uma thread por servidor R e envia pedidos em paralelo
4. **R** recebe subvetor e executa contagem paralela internamente
5. **R** retorna contagem parcial
6. **D** agrega resultados e compara com versão sequencial

## 🚀 Como Executar

### Pré-requisitos

- Java 8 ou superior
- Múltiplos terminais (recomendado) ou capacidade de executar processos em background

### 1. Compilação

```bash
cd /Users/rmartins/Desktop/maligno/ppd-java
javac -d out src/distributed/*.java
```

### 2. Executar Servidores R (Receptores)

**Opção A - Em terminais separados (recomendado):**

Terminal 1:
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

Terminal 2:
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12346
```

Terminal 3:
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12347
```

**Opção B - Em background:**
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12345 &
java -cp out distributed.ReceptorServer 0.0.0.0 12346 &
java -cp out distributed.ReceptorServer 0.0.0.0 12347 &
```

### 3. Executar o Distribuidor (D)

**Exemplo básico:**
```bash
java -cp out distributed.Distribuidor localhost:12345 localhost:12346 localhost:12347
```

**Com parâmetros personalizados:**
```bash
java -cp out distributed.Distribuidor localhost:12345 localhost:12346 localhost:12347 --tam 30000000 --missing
```

### 4. Executar Versão Sequencial (para comparação)

```bash
java -cp out distributed.ContagemSequencial 30000000 --missing
```

## 📋 Parâmetros Disponíveis

### Distribuidor
```bash
java -cp out distributed.Distribuidor [servidores...] [opções]

Servidores: host:porta (ex: localhost:12345)
Opções:
  --tam N      Tamanho do vetor (padrão: 10.000.000)
  --missing    Testa com número inexistente (111)
```

### ReceptorServer
```bash
java -cp out distributed.ReceptorServer [host] [porta]

host:  IP para bind (padrão: 0.0.0.0)
porta: Porta do servidor (padrão: 12345)
```

### ContagemSequencial
```bash
java -cp out distributed.ContagemSequencial [tamanho] [--missing]

tamanho: Tamanho do vetor (padrão: 10.000.000)
--missing: Testa com número inexistente (111)
```

## 🔧 Exemplo Completo de Execução

```bash
# 1. Compilar
cd /Users/rmartins/Desktop/maligno/ppd-java
javac -d out src/distributed/*.java

# 2. Iniciar servidores R (em terminais separados)
java -cp out distributed.ReceptorServer 0.0.0.0 12345
java -cp out distributed.ReceptorServer 0.0.0.0 12346  
java -cp out distributed.ReceptorServer 0.0.0.0 12347

# 3. Executar distribuidor
java -cp out distributed.Distribuidor localhost:12345 localhost:12346 localhost:12347 --tam 1000000 --missing

# 4. Comparar com versão sequencial
java -cp out distributed.ContagemSequencial 1000000 --missing
```

## 📊 Saída Esperada

### Saída do Distribuidor
```
[D] 2025-10-23 09:22:33 — Vetor gerado: 1000000 elementos; alvo escolhido (pos=523543) = 78
[D] 2025-10-23 09:22:33 — Conectado a localhost:12345
[D] 2025-10-23 09:22:33 — Conectado a localhost:12346
[D] 2025-10-23 09:22:33 — Conectado a localhost:12347
[D] 2025-10-23 09:22:33 — — Rodada EXISTENTE — alvo=78
[D] 2025-10-23 09:22:34 — Resposta de localhost:12346: parcial=1719
[D] 2025-10-23 09:22:34 — Resposta de localhost:12345: parcial=1676
[D] 2025-10-23 09:22:34 — Resposta de localhost:12347: parcial=1676
[D] 2025-10-23 09:22:34 — TOTAL (EXISTENTE): 5071 ocorrências. Tempo distribuído: 61,84 ms
[D] 2025-10-23 09:22:34 — Tempo sequencial local: 2,14 ms (resultado=5071)
[D] 2025-10-23 09:22:34 — — Rodada INEXISTENTE — alvo=111
[D] 2025-10-23 09:22:34 — Resposta de localhost:12346: parcial=0
[D] 2025-10-23 09:22:34 — Resposta de localhost:12347: parcial=0
[D] 2025-10-23 09:22:34 — Resposta de localhost:12345: parcial=0
[D] 2025-10-23 09:22:34 — TOTAL (INEXISTENTE): 0 ocorrências. Tempo distribuído: 41,27 ms
[D] 2025-10-23 09:22:34 — Tempo sequencial local: 3,23 ms (resultado=0)
[D] 2025-10-23 09:22:34 — Conexão fechada: localhost:12345
[D] 2025-10-23 09:22:34 — Conexão fechada: localhost:12346
[D] 2025-10-23 09:22:34 — Conexão fechada: localhost:12347
[D] 2025-10-23 09:22:34 — Encerramento enviado para todos os R e conexões fechadas.
```

### Saída dos Servidores R
```
[R] 2025-10-23 09:22:13 — Servidor R ouvindo em 0.0.0.0:12345
[R] 2025-10-23 09:22:33 — Conexão aceita de /127.0.0.1:50406
[R] 2025-10-23 09:22:33 — Pedido recebido de /127.0.0.1:50406 — procurando: 78, tamanho: 333334
[R] 2025-10-23 09:22:34 — Pedido recebido de /127.0.0.1:50406 — procurando: 111, tamanho: 333334
[R][WARN] 2025-10-23 09:22:34 — Encerramento recebido de /127.0.0.1:50406
[R] 2025-10-23 09:22:34 — Conexão encerrada: /127.0.0.1:50406
```

### Saída da Versão Sequencial
```
[SEQ] 2025-10-23 09:22:09 — Rodada EXISTENTE — procurando 69
[SEQ] 2025-10-23 09:22:09 — Resultado=4898, Tempo=2,27 ms
[SEQ] 2025-10-23 09:22:09 — Rodada INEXISTENTE — procurando 111
[SEQ] 2025-10-23 09:22:09 — Resultado=0, Tempo=0,19 ms
```

## ✅ Requisitos Técnicos Atendidos

- **✅ Comunicação TCP/IP** com serialização de objetos (ObjectInputStream/ObjectOutputStream)
- **✅ Conexões persistentes**: sockets mantidos abertos até ComunicadoEncerramento
- **✅ Múltiplas threads no R**: limitadas por availableProcessors()
- **✅ Sincronização**: CountDownLatch no D para coordenar threads
- **✅ Contagem de número inexistente**: flag --missing (resultado esperado: 0)
- **✅ Sistema de logs**: informativos em ambos os programas
- **✅ Versão sequencial**: para comparação de performance
- **✅ Classe utilitária**: MaiorVetorAproximado para estimar tamanho máximo

## 🏗️ Estrutura do Projeto

```
ppd-java/
├── src/distributed/
│   ├── Comunicado.java              # Classe base para comunicação
│   ├── ComunicadoEncerramento.java  # Sinal de encerramento
│   ├── ContagemSequencial.java      # Versão sequencial
│   ├── Distribuidor.java            # Cliente coordenador
│   ├── Log.java                     # Sistema de logs
│   ├── MaiorVetorAproximado.java    # Utilitário para estimar tamanho
│   ├── Pedido.java                  # Pedido de contagem
│   ├── ReceptorServer.java          # Servidor receptor
│   └── Resposta.java                # Resposta do servidor
├── out/                             # Classes compiladas
└── README.md                        # Este arquivo
```

## 🔍 Funcionalidades

### Distribuidor (D)
- Gera vetor de números aleatórios [-100, 100]
- Divide vetor em partes iguais para cada servidor R
- Cria uma thread por servidor R
- Agrega resultados parciais
- Compara com versão sequencial local
- Suporte a contagem de número inexistente

### ReceptorServer (R)
- Aceita conexões TCP
- Processa pedidos de contagem em paralelo
- Usa múltiplas threads (limitadas por availableProcessors())
- Mantém conexões persistentes
- Retorna contagem parcial

### ContagemSequencial
- Implementação sequencial para comparação
- Medição de tempo precisa
- Suporte a contagem de número inexistente

## 🛠️ Troubleshooting

### Problemas Comuns

1. **Porta já em uso**: Mude a porta do servidor R
2. **Conexão recusada**: Verifique se os servidores R estão rodando
3. **OutOfMemoryError**: Reduza o tamanho do vetor com --tam
4. **Compilação falha**: Verifique se está no diretório correto

### Comandos de Diagnóstico

```bash
# Verificar se as portas estão em uso
netstat -an | grep 12345

# Verificar processos Java
jps -l

# Matar processos se necessário
kill -9 <PID>
```

## 📈 Análise de Performance

O sistema permite comparar:
- **Tempo distribuído**: Soma do tempo de processamento em paralelo
- **Tempo sequencial**: Tempo de processamento em uma única thread
- **Overhead de rede**: Diferença entre distribuído e sequencial

## 🎯 Casos de Uso

1. **Teste básico**: Vetor pequeno (1M elementos)
2. **Teste de stress**: Vetor grande (30M+ elementos)
3. **Teste de número inexistente**: Verificar comportamento com --missing
4. **Comparação de performance**: Distribuído vs sequencial

## 📝 Notas Técnicas

- **Serialização**: Todas as classes de comunicação implementam Serializable
- **Thread Safety**: LongAdder para soma thread-safe
- **Sincronização**: CountDownLatch para coordenar múltiplas threads
- **Logs**: Sistema de logs com timestamps e níveis (info, warn, error)
- **Conexões**: TCP com TcpNoDelay habilitado para melhor performance