# Sistema Distribuído de Contagem Sequencial

## 📋 Visão Geral

Este projeto implementa um **sistema distribuído** para contagem de elementos em vetores grandes, demonstrando conceitos de **programação paralela e distribuída** em Java. O sistema compara a performance entre processamento **sequencial** e **distribuído** para encontrar a quantidade de ocorrências de um número específico em um vetor.

## 🏗️ Arquitetura do Sistema

### Componentes Principais

#### 🖥️ **CLIENTE**
- **Distribuidor (D)** - Coordena todo o processamento distribuído

#### 🖥️ **SERVIDORES** 
- **ReceptorServer (R)** - Processa partes do vetor em paralelo
- **Múltiplas instâncias** - Cada servidor processa um bloco diferente

#### 📊 **REFERÊNCIA**
- **ContagemSequencial** - Versão sequencial para comparação de performance

### Fluxo de Execução

```
CLIENTE (Distribuidor)          SERVIDORES (ReceptorServer)
     ↓                              ↓
1. Gera vetor grande           1. Ficam aguardando conexões
     ↓                              ↓
2. Divide vetor em blocos      2. Recebem pedidos de processamento
     ↓                              ↓
3. Envia blocos para servidores 3. Processam em paralelo (threads)
     ↓                              ↓
4. Coleta resultados parciais  4. Retornam contagens parciais
     ↓                              ↓
5. Soma resultados totais      5. Aguardam próximos pedidos
     ↓
6. Compara com versão sequencial
```

## 📁 Estrutura do Código

### Classes de Comunicação (Compartilhadas)

#### `Comunicado.java`
```java
public class Comunicado implements Serializable {
    private static final long serialVersionUID = 1L;
}
```
- **Função**: Classe base para comunicação entre Cliente e Servidor
- **Características**: Implementa `Serializable` para transmissão via rede

#### `ComunicadoEncerramento.java`
```java
public class ComunicadoEncerramento extends Comunicado {
    private static final long serialVersionUID = 4L;
}
```
- **Função**: Sinaliza encerramento de conexões
- **Uso**: Enviado pelo **CLIENTE** para finalizar **SERVIDORES**

#### `Pedido.java`
```java
public class Pedido extends Comunicado {
    private final int[] numeros;
    private final int procurado;
    
    public int contar() {
        // Processamento paralelo usando ExecutorService
        // Divide o vetor entre threads disponíveis
    }
}
```
- **Função**: Contém o vetor e número a ser procurado
- **Processamento**: Implementa contagem paralela usando `ExecutorService`
- **Otimização**: Usa `LongAdder` para soma thread-safe

#### `Resposta.java`
```java
public class Resposta extends Comunicado {
    private final Integer contagem;
}
```
- **Função**: Retorna o resultado da contagem
- **Características**: Usa `Integer` para permitir valores `null`

---

## 🖥️ **CÓDIGO DO CLIENTE**

### **Distribuidor.java** - Cliente Coordenador

#### **Responsabilidades do Cliente:**
- ✅ Gera vetor aleatório de tamanho configurável
- ✅ Conecta com múltiplos servidores simultaneamente
- ✅ Divide o vetor em blocos iguais para cada servidor
- ✅ Envia blocos para servidores em paralelo
- ✅ Coleta e soma resultados parciais de todos os servidores
- ✅ Compara performance: distribuído vs sequencial

#### **Características Técnicas:**
- **Threading**: Usa threads para comunicação paralela com servidores
- **Divisão Inteligente**: Calcula blocos de tamanho igual para cada servidor
- **Medição Precisa**: Cronometra tempo de processamento distribuído vs sequencial
- **Gerenciamento de Conexão**: Classe interna `Connection` para gerenciar sockets
- **Robustez**: Trata falhas de conexão e timeouts

#### **Exemplo de Uso:**
```bash
java -cp out distributed.Distribuidor 192.168.1.100:12345 192.168.1.101:12346 --tam 1000000 --missing
```

#### **Código Principal do Cliente:**
```java
public class Distribuidor {
    public static void main(String[] args) throws Exception {
        // 1. Parse dos argumentos (servidores, tamanho, etc.)
        List<String> destinos = new ArrayList<>();
        int tamanho = 10_000_000;
        
        // 2. Gerar vetor aleatório
        Random rnd = new Random();
        int[] vetor = new int[tamanho];
        for (int i = 0; i < tamanho; i++) 
            vetor[i] = rnd.nextInt(201) - 100;
        
        // 3. Conectar com servidores
        List<Connection> conns = new ArrayList<>();
        for (String alvo : destinos) {
            String[] hp = alvo.split(":");
            conns.add(new Connection(hp[0], Integer.parseInt(hp[1])));
        }
        
        // 4. Executar processamento distribuído
        executarRodada("EXISTENTE", conns, vetor, procurado);
        
        // 5. Encerrar conexões
        for (Connection c : conns) {
            c.sendEncerramento();
            c.close();
        }
    }
}
```

---

## 🖥️ **CÓDIGO DO SERVIDOR**

### **ReceptorServer.java** - Servidor de Processamento

#### **Responsabilidades do Servidor:**
- ✅ Fica aguardando conexões de clientes
- ✅ Aceita múltiplas conexões simultâneas
- ✅ Recebe pedidos de processamento (`Pedido`)
- ✅ Processa contagem em paralelo usando threads
- ✅ Retorna resultados via rede (`Resposta`)
- ✅ Gerencia encerramento de conexões

#### **Características Técnicas:**
- **Concorrência**: Uma thread por conexão (`Atendedor`)
- **Protocolo de Comunicação**: Processa `Pedido` e `ComunicadoEncerramento`
- **Processamento Paralelo**: Usa `ExecutorService` para otimizar contagem
- **Robustez**: Trata exceções de rede e objetos desconhecidos
- **Logging Detalhado**: Registra todas as operações para debug

#### **Exemplo de Uso:**
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

#### **Código Principal do Servidor:**
```java
public class ReceptorServer {
    public static void main(String[] args) {
        String hostBind = args.length > 0 ? args[0] : "0.0.0.0";
        int porta = args.length > 1 ? Integer.parseInt(args[1]) : 12345;

        try (ServerSocket servidor = new ServerSocket()) {
            servidor.bind(new InetSocketAddress(hostBind, porta));
            Log.info("R", "Servidor R ouvindo em " + hostBind + ":" + porta);

            while (true) {
                // 1. Aceitar conexão do cliente
                Socket conexao = servidor.accept();
                Log.info("R", "Conexão aceita de " + conexao.getRemoteSocketAddress());
                
                // 2. Criar thread para atender cliente
                new Thread(new Atendedor(conexao)).start();
            }
        } catch (IOException e) {
            Log.error("R", "Falha ao iniciar servidor", e);
        }
    }
}
```

#### **Classe Atendedor (Thread do Servidor):**
```java
private static class Atendedor implements Runnable {
    private final Socket socket;
    
    @Override public void run() {
        try (ObjectOutputStream transmissor = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream receptor = new ObjectInputStream(socket.getInputStream())) {
            
            while (true) {
                Object obj = receptor.readObject();
                
                if (obj instanceof Pedido) {
                    // 1. Receber pedido do cliente
                    Pedido p = (Pedido) obj;
                    
                    // 2. Processar contagem em paralelo
                    int cont = p.contar();
                    
                    // 3. Enviar resposta
                    transmissor.writeObject(new Resposta(cont));
                    transmissor.flush();
                    
                } else if (obj instanceof ComunicadoEncerramento) {
                    // 4. Encerrar conexão
                    break;
                }
            }
        } catch (Exception e) {
            Log.error("R", "Erro na conexão", e);
        }
    }
}
```

---

## 📊 **REFERÊNCIA - ContagemSequencial.java**

### **Função:**
- Implementa contagem sequencial simples (não distribuída)
- Serve como **baseline** para comparação de performance
- Suporta teste com números existentes e inexistentes

### **Características:**
- **Simplicidade**: Algoritmo linear O(n) em uma única thread
- **Medição Precisa**: Cronometra tempo de execução em nanosegundos
- **Flexibilidade**: Aceita parâmetros de tamanho e tipo de teste
- **Comparação**: Permite medir o ganho de performance do sistema distribuído

---

## 🔄 **COMUNICAÇÃO CLIENTE ↔ SERVIDOR**

### **Fluxo de Dados:**
```
CLIENTE (Distribuidor)          SERVIDOR (ReceptorServer)
     ↓                              ↓
1. Gera vetor[1M]              1. Aguarda conexão
     ↓                              ↓
2. Divide em blocos            2. Aceita conexão
     ↓                              ↓
3. Envia Pedido(bloco, alvo)   3. Recebe Pedido
     ↓                              ↓
4. Aguarda Resposta            4. Processa p.contar()
     ↓                              ↓
5. Recebe Resposta(contagem)   5. Envia Resposta(contagem)
     ↓                              ↓
6. Soma resultados             6. Aguarda próximo pedido
     ↓                              ↓
7. Envia ComunicadoEncerramento 7. Encerra conexão
```

### **Protocolo de Comunicação:**
- **Pedido**: `{int[] numeros, int procurado}` → Cliente para Servidor
- **Resposta**: `{Integer contagem}` → Servidor para Cliente  
- **Encerramento**: `ComunicadoEncerramento` → Cliente para Servidor

### Utilitários

#### `Log.java` - Sistema de Logging

```java
public final class Log {
    public static void info(String tag, String msg);
    public static void warn(String tag, String msg);
    public static void error(String tag, String msg, Throwable t);
}
```

**Características:**
- **Thread-safe**: Métodos estáticos seguros para concorrência
- **Formatação**: Timestamp automático e tags identificadoras
- **Níveis**: Info, Warning e Error com stack traces

## 🚀 Como Executar

### 1. Compilação
```bash
javac -d out src/distributed/*.java
```

### 2. Teste Sequencial (Referência)
```bash
java -cp out distributed.ContagemSequencial 10000 --missing
```

### 3. Teste Distribuído

#### **Passo 1: Iniciar os SERVIDORES**

**Terminal 1 - Servidor 1:**
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12345
```

**Terminal 2 - Servidor 2:**
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12346
```

**Terminal 3 - Servidor 3:**
```bash
java -cp out distributed.ReceptorServer 0.0.0.0 12347
```

#### **Passo 2: Executar o CLIENTE**

**Terminal 4 - Cliente (Distribuidor):**
```bash
java -cp out distributed.Distribuidor 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347 --tam 1000000 --missing
```

### 4. Teste Automatizado (Recomendado)
```bash
chmod +x teste_rede.sh
./teste_rede.sh
```

## 📊 Conceitos Demonstrados

### 1. **Programação Distribuída**
- Comunicação via sockets TCP
- Serialização de objetos Java
- Protocolo cliente-servidor

### 2. **Programação Paralela**
- `ExecutorService` para processamento paralelo
- `LongAdder` para soma thread-safe
- Divisão de trabalho entre threads

### 3. **Concorrência**
- Múltiplas conexões simultâneas
- Sincronização de recursos compartilhados
- Gerenciamento de threads

### 4. **Otimização de Performance**
- Comparação sequencial vs distribuído
- Medição precisa de tempo (nanosegundos)
- Análise de escalabilidade

## 🔧 Parâmetros de Configuração

### Distribuidor
- `--tam N`: Tamanho do vetor (padrão: 10.000.000)
- `--missing`: Testa com número inexistente
- `host:porta`: Endereços dos servidores

### ReceptorServer
- `host`: IP para bind (padrão: 0.0.0.0)
- `porta`: Porta de escuta (padrão: 12345)

## 📈 Análise de Performance

O sistema permite comparar:

1. **Tempo Sequencial**: Processamento em uma única thread
2. **Tempo Distribuído**: Processamento dividido entre servidores
3. **Speedup**: Ganho de performance com paralelização
4. **Eficiência**: Relação entre speedup e número de servidores

## 🎯 Objetivos de Aprendizado

1. **Compreender** arquiteturas cliente-servidor
2. **Implementar** comunicação distribuída em Java
3. **Aplicar** conceitos de programação paralela
4. **Medir** e analisar performance de sistemas distribuídos
5. **Gerenciar** recursos de rede e concorrência

## 🛠️ Tecnologias Utilizadas

- **Java**: Linguagem de programação
- **Sockets TCP**: Comunicação de rede
- **Serialização**: Transmissão de objetos
- **ExecutorService**: Pool de threads
- **Concurrent Collections**: Estruturas thread-safe

## 📝 Logs e Debugging

O sistema gera logs detalhados para cada componente:
- **Tag "D"**: Distribuidor
- **Tag "R"**: ReceptorServer  
- **Tag "SEQ"**: ContagemSequencial

Exemplo de log:
```
[D] 2024-01-15 10:30:15 — Vetor gerado: 1000000 elementos; alvo escolhido (pos=123456) = 42
[R] 2024-01-15 10:30:16 — Pedido recebido de /127.0.0.1:54321 — procurando: 42, tamanho: 500000
[D] 2024-01-15 10:30:17 — TOTAL (EXISTENTE): 1000 ocorrências. Tempo distribuído: 45.67 ms
```

Este sistema demonstra de forma prática os conceitos fundamentais de programação distribuída e paralela, sendo uma excelente base para entender como sistemas modernos processam grandes volumes de dados de forma eficiente.
