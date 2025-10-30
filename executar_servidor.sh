#!/bin/bash

# Script para executar servidor em máquina remota
# Uso: ./executar_servidor.sh [PORTA] [IP_BIND]

PORTA=${1:-12345}
IP_BIND=${2:-0.0.0.0}

echo "🖥️  Iniciando Servidor..."
echo "========================="
echo "IP: $IP_BIND"
echo "Porta: $PORTA"
echo ""

# Compilar se necessário
if [ ! -d "out" ]; then
    echo "📦 Compilando servidor..."
    ./compilar.sh
fi

echo "🚀 Executando servidor..."
echo "Pressione Ctrl+C para parar"
echo ""

java -cp out:../shared/out distributed.ReceptorServer $IP_BIND $PORTA
