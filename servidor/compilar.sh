#!/bin/bash

echo "🔨 Compilando SERVIDOR..."
echo "========================="

# Criar diretório de saída
mkdir -p out

# Compilar classes compartilhadas primeiro
echo "📦 Compilando classes compartilhadas..."
javac -d out ../shared/src/distributed/*.java

# Compilar servidor
echo "🖥️  Compilando servidor..."
javac -cp out -d out src/distributed/*.java

echo "✅ Servidor compilado com sucesso!"
echo "📁 Classes em: servidor/out/distributed/"
echo ""
echo "🚀 Para executar:"
echo "   java -cp out:../shared/out distributed.ReceptorServer 0.0.0.0 12345"
