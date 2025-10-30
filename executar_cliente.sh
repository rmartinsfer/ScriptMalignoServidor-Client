#!/bin/bash

# Script para executar cliente conectando a servidores remotos
# Uso: ./executar_cliente.sh IP1:porta1 IP2:porta2 [--tam TAMANHO] [--missing]

if [ $# -lt 2 ]; then
    echo "❌ Uso: $0 IP1:porta1 IP2:porta2 [--tam TAMANHO] [--missing]"
    echo ""
    echo "Exemplos:"
    echo "  $0 192.168.1.100:12345 192.168.1.101:12346"
    echo "  $0 192.168.1.100:12345 192.168.1.101:12346 --tam 1000000 --missing"
    exit 1
fi

echo "🖥️  Iniciando Cliente..."
echo "========================"
echo "Conectando aos servidores: $@"
echo ""

# Compilar se necessário
if [ ! -d "out" ]; then
    echo "📦 Compilando cliente..."
    ./compilar.sh
fi

echo "🚀 Executando cliente..."
echo ""

java -cp out:../shared/out distributed.Distribuidor "$@"
