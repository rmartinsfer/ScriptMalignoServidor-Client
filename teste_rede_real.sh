#!/bin/bash

# Script de Teste em Ambiente Real - Sistema Distribuído
# Execute este script na máquina coordenadora com IPs das outras máquinas

echo "🌐 TESTE EM AMBIENTE REAL - SISTEMA DISTRIBUÍDO"
echo "=============================================="
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Função para testar conectividade
test_connection() {
    local host=$1
    local port=$2
    local timeout=5
    
    if timeout $timeout bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Verificar se IPs foram fornecidos
if [ $# -eq 0 ]; then
    print_error "Nenhum IP fornecido!"
    echo ""
    print_info "Uso: ./teste_rede_real.sh IP1:porta IP2:porta IP3:porta"
    echo ""
    print_info "Exemplos:"
    print_info "• ./teste_rede_real.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345"
    print_info "• ./teste_rede_real.sh 172.16.21.50:12345 172.16.21.22:12345 172.16.21.23:12345"
    echo ""
    print_info "📝 Primeiro, execute em cada máquina da rede:"
    print_info "   ./preparar_maquina.sh"
    exit 1
fi

# 1. Compilar projeto
print_info "1. Compilando projeto..."
if ! javac -d out src/distributed/*.java; then
    print_error "Falha na compilação!"
    exit 1
fi
print_success "Compilação OK!"

# 2. Teste sequencial
print_info "2. Testando versão sequencial para comparação..."
if ! java -cp out distributed.ContagemSequencial 1000 --missing; then
    print_error "Falha na versão sequencial!"
    exit 1
fi
print_success "Versão sequencial OK!"

# 3. Teste de conectividade
print_info "3. Testando conectividade com máquinas da rede..."
all_connected=true

for ip_port in "$@"; do
    if [[ $ip_port == *":"* ]]; then
        IFS=':' read -r host port <<< "$ip_port"
        print_info "🔍 Testando $host:$port..."
        
        if test_connection "$host" "$port"; then
            print_success "Conexão com $host:$port OK!"
        else
            print_error "Falha na conexão com $host:$port"
            print_warning "Verifique se o ReceptorServer está rodando nesta máquina"
            all_connected=false
        fi
    fi
done

if [ "$all_connected" = false ]; then
    print_warning "Alguns servidores não estão respondendo"
    print_info "Tentando continuar mesmo assim..."
fi
echo ""

# 4. Teste distribuído em ambiente real
print_info "4. Executando teste distribuído em ambiente real..."
print_info "📊 Logs mostrarão comunicação entre IPs diferentes:"
print_info "   [D] Conectado a 192.168.1.XXX:12345"
print_info "   [R] Pedido recebido do cliente 192.168.1.XXX:XXXXX"
print_info "   [D] Resposta de 192.168.1.XXX:12345: parcial=X"
echo ""

# Executar teste distribuído
java -cp out distributed.Distribuidor "$@" --tam 1000000 --missing

if [ $? -eq 0 ]; then
    print_success "Teste distribuído executado com sucesso!"
else
    print_error "Falha no teste distribuído!"
    print_warning "Verifique se todos os servidores R estão rodando nas máquinas"
    exit 1
fi

# 5. Teste com vetor maior
print_info "5. Testando com vetor maior (10M elementos)..."
java -cp out distributed.Distribuidor "$@" --tam 10000000

if [ $? -eq 0 ]; then
    print_success "Teste com vetor maior executado com sucesso!"
else
    print_error "Falha no teste com vetor maior!"
    exit 1
fi

echo ""
print_success "🎉 TESTE EM AMBIENTE REAL EXECUTADO COM SUCESSO!"
print_success "🚀 Sistema funcionando perfeitamente em rede local!"
print_info "📝 Logs mostram comunicação entre máquinas diferentes"
print_info "📝 IPs testados: $*"
echo ""
print_success "✨ Sistema pronto para demonstração ao professor!"
print_info "📋 Vantagens do teste em ambiente real:"
print_info "   ✅ Comunicação real entre máquinas"
print_info "   ✅ Logs mostram IPs diferentes (ex: 192.168.1.100 → 192.168.1.101)"
print_info "   ✅ Distribuição real do trabalho"
print_info "   ✅ Teste de rede local autêntico"
