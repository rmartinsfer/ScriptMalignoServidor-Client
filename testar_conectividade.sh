#!/bin/bash

# Script para testar conectividade com servidores
# Uso: ./testar_conectividade.sh IP1:porta1 IP2:porta2

if [ $# -lt 1 ]; then
    echo "❌ Uso: $0 IP1:porta1 [IP2:porta2] ..."
    echo ""
    echo "Exemplos:"
    echo "  $0 192.168.1.100:12345"
    echo "  $0 192.168.1.100:12345 192.168.1.101:12346"
    exit 1
fi

echo "🔍 Testando Conectividade..."
echo "============================"
echo ""

for servidor in "$@"; do
    IFS=':' read -r IP PORTA <<< "$servidor"
    
    echo -n "Testando $servidor... "
    
    if timeout 5 bash -c "echo > /dev/tcp/$IP/$PORTA" 2>/dev/null; then
        echo "✅ CONECTADO"
    else
        echo "❌ FALHOU"
        echo "   Verifique se:"
        echo "   - O servidor está rodando na máquina $IP"
        echo "   - A porta $PORTA está aberta"
        echo "   - Não há firewall bloqueando"
    fi
done

echo ""
echo "💡 Dica: Se a conexão falhar, verifique:"
echo "   1. IPs estão corretos"
echo "   2. Servidores estão rodando"
echo "   3. Portas estão abertas"
echo "   4. Firewall não está bloqueando"
