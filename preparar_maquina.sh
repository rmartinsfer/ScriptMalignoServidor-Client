#!/bin/bash

# Script de Preparação para Teste em Ambiente Real
# Execute este script em cada máquina da rede local

echo "🔧 PREPARANDO MÁQUINA PARA TESTE DISTRIBUÍDO"
echo "==========================================="
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

# 1. Compilar projeto
print_info "1. Compilando projeto..."
if ! javac -d out src/distributed/*.java; then
    print_error "Falha na compilação!"
    print_warning "Verifique se está no diretório correto: cd ppd-java"
    exit 1
fi
print_success "Compilação OK!"

# 2. Descobrir IP da máquina
print_info "2. Descobrindo IP da máquina..."

if command -v ip >/dev/null 2>&1; then
    # Linux com ip command
    LOCAL_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -1)
elif command -v ifconfig >/dev/null 2>&1; then
    # macOS/Linux com ifconfig
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)
else
    print_warning "Comandos 'ip' e 'ifconfig' não encontrados"
    LOCAL_IP="IP_DESCONHECIDO"
fi

if [[ $LOCAL_IP == "IP_DESCONHECIDO" || -z $LOCAL_IP ]]; then
    print_warning "Não foi possível descobrir o IP automaticamente"
    print_info "Execute manualmente: ifconfig (Linux/macOS) ou ipconfig (Windows)"
    print_info "Anote o IP e informe para a máquina coordenadora"
else
    print_success "IP da máquina: $LOCAL_IP"
    print_info "📝 Anote este IP para usar no teste distribuído"
fi

# 3. Verificar se porta está livre
print_info "3. Verificando se porta 12345 está livre..."
if netstat -an | grep -q ":12345.*LISTEN"; then
    print_warning "Porta 12345 já está em uso"
    print_info "Execute: pkill -f 'distributed.ReceptorServer' para liberar a porta"
else
    print_success "Porta 12345 está livre"
fi

# 4. Iniciar ReceptorServer
print_info "4. Iniciando ReceptorServer..."
print_info "   O servidor ficará rodando até você pressionar Ctrl+C"
print_info "   Logs mostrarão: [R] Servidor R ouvindo em 0.0.0.0:12345"
echo ""

print_success "🚀 Iniciando ReceptorServer..."
print_info "📝 Logs esperados:"
print_info "   [R] Servidor R ouvindo em 0.0.0.0:12345"
print_info "   [R] Conexão aceita de /192.168.1.XXX:XXXXX"
print_info "   [R] Pedido recebido do cliente /192.168.1.XXX:XXXXX"
echo ""

# Iniciar ReceptorServer
java -cp out distributed.ReceptorServer 0.0.0.0 12345
