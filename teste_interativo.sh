#!/bin/bash

# Script de Teste Interativo - Sistema Distribuído
# Permite entrada de IPs IPv4 via teclado

echo "🌐 TESTE INTERATIVO - SISTEMA DISTRIBUÍDO"
echo "========================================"
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

# Função para validar IPv4
validate_ipv4() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        local IFS='.'
        local -a octets=($ip)
        for octet in "${octets[@]}"; do
            if [[ $octet -gt 255 ]]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Função para validar porta
validate_port() {
    local port=$1
    if [[ $port =~ ^[0-9]+$ ]] && [[ $port -ge 1 ]] && [[ $port -le 65535 ]]; then
        return 0
    else
        return 1
    fi
}

# 1. Compilar projeto
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
print_success "Versão sequencial OK!"

# 3. Entrada interativa de IPs
echo ""
print_info "3. Entrada de IPs IPv4 para teste distribuído"
print_info "Digite os IPs no formato: IP:PORTA"
print_info "Exemplo: 192.168.1.100:12345"
print_info "Pressione ENTER sem digitar nada para finalizar"
echo ""

IPS=()
contador=1

while true; do
    echo -n "IP $contador (formato IPv4:porta): "
    read -r entrada
    
    if [[ -z "$entrada" ]]; then
        break
    fi
    
    if [[ $entrada == *":"* ]]; then
        IFS=':' read -r ip porta <<< "$entrada"
        
        if validate_ipv4 "$ip"; then
            if validate_port "$porta"; then
                IPS+=("$entrada")
                print_success "IP $contador adicionado: $entrada"
                contador=$((contador + 1))
            else
                print_error "Porta inválida: $porta (deve ser 1-65535)"
            fi
        else
            print_error "IPv4 inválido: $ip"
            print_info "Formato correto: 192.168.1.100"
        fi
    else
        print_error "Formato inválido. Use: IP:PORTA"
        print_info "Exemplo: 192.168.1.100:12345"
    fi
done

if [ ${#IPS[@]} -eq 0 ]; then
    print_error "Nenhum IP fornecido!"
    exit 1
fi

print_success "Total de IPs: ${#IPS[@]}"
print_info "IPs coletados: ${IPS[*]}"
echo ""

# 4. Iniciar servidores R automaticamente (se IPs forem locais)
print_info "4. Iniciando servidores R automaticamente..."
servers_started=0

for ip_port in "${IPS[@]}"; do
    if [[ $ip_port == *":"* ]]; then
        IFS=':' read -r host port <<< "$ip_port"
        
        if [[ "$host" == "127.0.0.1" || "$host" == "localhost" ]]; then
            print_info "Iniciando servidor R em $ip_port..."
            java -cp out distributed.ReceptorServer 0.0.0.0 "$port" > /dev/null 2>&1 &
            servers_started=$((servers_started + 1))
            sleep 2
        else
            print_info "IP externo $ip_port - assumindo que servidor R já está rodando"
        fi
    fi
done

if [ $servers_started -gt 0 ]; then
    print_success "$servers_started servidores R iniciados automaticamente!"
    sleep 3
fi

# 5. Teste de conectividade
print_info "5. Testando conectividade com servidores R..."
all_connected=true

for ip_port in "${IPS[@]}"; do
    if [[ $ip_port == *":"* ]]; then
        IFS=':' read -r host port <<< "$ip_port"
        print_info "Testando $host:$port..."
        
        if timeout 5 bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
            print_success "Conexão com $host:$port OK!"
        else
            print_error "Falha na conexão com $host:$port"
            print_warning "Verifique se o ReceptorServer está rodando neste IP"
            all_connected=false
        fi
    fi
done

if [ "$all_connected" = false ]; then
    print_warning "Alguns servidores não estão respondendo"
    print_info "Tentando continuar mesmo assim..."
fi
echo ""

# 6. Teste distribuído
print_info "6. Testando sistema distribuído..."
print_info "IPs fornecidos: ${IPS[*]}"
echo ""

if ! java -cp out distributed.Distribuidor "${IPS[@]}" --tam 10000 --missing; then
    print_error "Falha no teste distribuído!"
    exit 1
fi

print_success "Teste distribuído OK!"

# 7. Teste com vetor maior
print_info "7. Testando com vetor maior (100K elementos)..."
if ! java -cp out distributed.Distribuidor "${IPS[@]}" --tam 100000; then
    print_error "Falha no teste com vetor maior!"
    exit 1
fi
print_success "Teste com vetor maior OK!"

echo ""
print_success "🎉 TESTE INTERATIVO CONCLUÍDO COM SUCESSO!"
print_success "🚀 Sistema funcionando perfeitamente!"
print_info "📝 IPs testados: ${IPS[*]}"

echo ""
print_success "✨ Sistema pronto para demonstração ao professor!"

# Limpeza
echo ""
print_info "Limpando processos em background..."
pkill -f "distributed.ReceptorServer" 2>/dev/null || true
sleep 2
