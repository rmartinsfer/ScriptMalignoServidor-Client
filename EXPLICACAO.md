# Sistema Distribuído - Trabalho PPD

## O que faz

Este sistema conta quantas vezes um número aparece em um vetor grande. A diferença é que ele divide o trabalho entre vários computadores para ser mais rápido.

## Como funciona

1. **Distribuidor (D)**: É o programa principal que coordena tudo
2. **Servidores R**: São programas que fazem a contagem em paralelo
3. **ContagemSequencial**: Versão normal para comparar

## Como usar

### Teste local (na mesma máquina):
```bash
./teste_automatico.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347
```

### Teste em rede (máquinas diferentes):
```bash
# Em cada máquina da rede:
java -cp out distributed.ReceptorServer 0.0.0.0 12345

# Em uma máquina:
./teste_automatico.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345
```

## Arquivos principais

- `Distribuidor.java` - Programa principal
- `ReceptorServer.java` - Servidor que faz a contagem
- `ContagemSequencial.java` - Versão normal para comparar
- `Pedido.java` - Classe que manda os dados
- `Resposta.java` - Classe que retorna o resultado

## Compilar e executar

```bash
# Compilar
javac -d out src/distributed/*.java

# Executar servidor
java -cp out distributed.ReceptorServer 0.0.0.0 12345

# Executar distribuidor
java -cp out distributed.Distribuidor localhost:12345 localhost:12346 --tam 1000000
```

## O que o sistema mostra

- Quantas vezes o número aparece
- Tempo que levou para processar
- Comparação entre versão distribuída e normal

## Requisitos

- Java 8 ou superior
- Múltiplas máquinas para teste em rede (opcional)

## Problemas comuns

- **Porta já em uso**: Mude a porta do servidor
- **Conexão recusada**: Verifique se os servidores estão rodando
- **Falha na compilação**: Verifique se está no diretório correto
