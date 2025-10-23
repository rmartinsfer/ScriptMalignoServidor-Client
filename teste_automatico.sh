#!/bin/bash

# Script Automático Completo - Sistema Distribuído
# Inicia servidores R automaticamente e executa teste
# Uso: ./teste_automatico.sh IP1:porta IP2:porta IP3:porta

echo "🚀 TESTE AUTOMÁTICO COMPLETO"
echo "============================"
echo ""

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Função para limpeza
cleanup() {
    echo ""
    print_info "Limpando processos em background..."
    pkill -f "distributed.ReceptorServer" 2>/dev/null || true
    pkill -f "distributed.Distribuidor" 2>/dev/null || true
    sleep 2
}

trap cleanup EXIT

# Verificar se IPs foram fornecidos
if [ $# -eq 0 ]; then
    print_error "Nenhum IP fornecido!"
    echo ""
    print_info "Uso: ./teste_automatico.sh IP1:porta IP2:porta IP3:porta"
    echo ""
    print_info "Exemplos:"
    print_info "• Teste local: ./teste_automatico.sh 127.0.0.1:12345 127.0.0.1:12346 127.0.0.1:12347"
    print_info "• Teste rede: ./teste_automatico.sh 192.168.1.100:12345 192.168.1.101:12345 192.168.1.102:12345"
    exit 1
fi

# 1. Compilar
print_info "1. Compilando projeto..."
if ! javac -d out src/distributed/*.java; then
    print_error "Falha na compilação!"
    exit 1
fi
print_success "Compilação OK!"

# 2. Teste sequencial
print_info "2. Testando versão sequencial..."
if ! java -cp out distributed.ContagemSequencial 1000 --missing; then
    print_error "Falha na versão sequencial!"
    exit 1
fi
print_success "Sequencial OK!"

# 3. Iniciar servidores R automaticamente (apenas para IPs locais)
print_info "3. Iniciando servidores R automaticamente..."
servers_started=0

for ip_port in "$@"; do
    if [[ $ip_port == *":"* ]]; then
        IFS=':' read -r host port <<< "$ip_port"
        
        # Se for localhost, iniciar servidor automaticamente
        if [[ $host == "127.0.0.1" || $host == "localhost" ]]; then
            print_info "Iniciando servidor R em $host:$port..."
            java -cp out distributed.ReceptorServer 0.0.0.0 $port > /dev/null 2>&1 &
            servers_started=$((servers_started + 1))
            sleep 1
        else
            print_info "IP externo $host:$port - assumindo que servidor R já está rodando"
        fi
    fi
done

if [ $servers_started -gt 0 ]; then
    print_success "$servers_started servidores R iniciados automaticamente!"
    sleep 2
fi

# 4. Teste distribuído
print_info "4. Testando sistema distribuído..."
print_info "IPs fornecidos: $*"
echo ""

if ! java -cp out distributed.Distribuidor "$@" --tam 10000 --missing; then
    print_error "Falha no teste distribuído!"
    print_info "Verifique se os servidores R estão rodando nos IPs fornecidos"
    exit 1
fi

print_success "Teste distribuído OK!"

# 5. Teste com vetor maior
print_info "5. Testando com vetor maior (100K elementos)..."
if ! java -cp out distributed.Distribuidor "$@" --tam 100000; then
    print_error "Falha no teste com vetor maior!"
    exit 1
fi
print_success "Teste com vetor maior OK!"

echo ""
print_success "🎉 TESTE AUTOMÁTICO CONCLUÍDO COM SUCESSO!"
print_success "🚀 Sistema funcionando perfeitamente!"
print_info "📝 IPs testados: $*"
echo ""
print_success "✨ Sistema pronto para demonstração ao professor!"