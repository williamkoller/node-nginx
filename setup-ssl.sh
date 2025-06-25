#!/bin/bash

set -e

echo "🚀 Configurando SSL/HTTPS para node-nginx..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar dependências
echo -e "${BLUE}📋 Verificando dependências...${NC}"
if ! command_exists docker; then
    echo -e "${RED}❌ Docker não encontrado. Instale o Docker primeiro.${NC}"
    exit 1
fi

if ! command_exists openssl; then
    echo -e "${RED}❌ OpenSSL não encontrado. Instale o OpenSSL primeiro.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Dependências verificadas${NC}"
echo ""

# Verificar se porta 443 está disponível
echo -e "${BLUE}🔍 Verificando disponibilidade da porta 443...${NC}"
if netstat -tlnp 2>/dev/null | grep -q ":443 "; then
    echo -e "${YELLOW}⚠️  Porta 443 em uso. O HTTPS pode não funcionar.${NC}"
else
    echo -e "${GREEN}✅ Porta 443 disponível${NC}"
fi

# Parar containers se estiverem rodando
echo -e "${BLUE}🛑 Parando containers existentes...${NC}"
docker compose down 2>/dev/null || true

# Gerar certificados SSL
echo -e "${BLUE}🔐 Gerando certificados SSL...${NC}"
chmod +x generate-certificate.sh
./generate-certificate.sh

# Configurar /etc/hosts se necessário
echo -e "${BLUE}🌐 Configurando /etc/hosts...${NC}"
if ! grep -q "node-nginx.local" /etc/hosts 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Adicionando entrada no /etc/hosts (requer sudo)${NC}"
    echo "127.0.0.1 node-nginx.local" | sudo tee -a /etc/hosts >/dev/null
    echo -e "${GREEN}✅ Entrada adicionada ao /etc/hosts${NC}"
else
    echo -e "${GREEN}✅ Entrada já existe no /etc/hosts${NC}"
fi

# Construir e iniciar containers
echo -e "${BLUE}🏗️  Construindo e iniciando containers...${NC}"
docker compose build --no-cache
docker compose up -d

# Aguardar containers iniciarem
echo -e "${BLUE}⏳ Aguardando containers iniciarem...${NC}"
sleep 8

# Verificar status dos containers
echo -e "${BLUE}📊 Status dos containers:${NC}"
docker compose ps

# Testar conectividade
echo ""
echo -e "${BLUE}🧪 Testando conectividade...${NC}"

# Testar HTTP na porta 8080 (deve redirecionar)
if curl -s -o /dev/null -w "%{http_code}" http://node-nginx.local:8080 2>/dev/null | grep -q "301"; then
    echo -e "${GREEN}✅ Redirecionamento HTTP:8080 → HTTPS funcionando${NC}"
else
    echo -e "${YELLOW}⚠️  Testando redirecionamento HTTP...${NC}"
    sleep 3
    if curl -s -o /dev/null -w "%{http_code}" http://node-nginx.local:8080 2>/dev/null | grep -q "301"; then
        echo -e "${GREEN}✅ Redirecionamento HTTP:8080 → HTTPS funcionando${NC}"
    else
        echo -e "${YELLOW}⚠️  Redirecionamento HTTP pode não estar funcionando${NC}"
    fi
fi

# Testar HTTPS
if curl -k -s -o /dev/null -w "%{http_code}" https://node-nginx.local 2>/dev/null | grep -q "200"; then
    echo -e "${GREEN}✅ HTTPS funcionando${NC}"
else
    echo -e "${YELLOW}⚠️  Testando HTTPS...${NC}"
    sleep 3
    if curl -k -s -o /dev/null -w "%{http_code}" https://node-nginx.local 2>/dev/null | grep -q "200"; then
        echo -e "${GREEN}✅ HTTPS funcionando${NC}"
    else
        echo -e "${YELLOW}⚠️  HTTPS pode não estar funcionando ainda${NC}"
        echo -e "${BLUE}💡 Verifique os logs: docker compose logs nginx${NC}"
    fi
fi

echo ""
echo -e "${GREEN}🎉 Configuração SSL/HTTPS concluída!${NC}"
echo ""
echo -e "${BLUE}📱 Como acessar sua aplicação:${NC}"
echo -e "   • HTTPS (recomendado): ${GREEN}https://node-nginx.local${NC}"
echo -e "   • HTTP (redireciona):  ${GREEN}http://node-nginx.local:8080${NC}"
echo -e "   • Localhost HTTPS:     ${GREEN}https://localhost${NC}"
echo ""
echo -e "${BLUE}🔧 Comandos úteis:${NC}"
echo -e "   • Ver logs:      ${YELLOW}docker compose logs -f${NC}"
echo -e "   • Ver logs Nginx: ${YELLOW}docker compose logs -f nginx${NC}"
echo -e "   • Parar:         ${YELLOW}docker compose down${NC}"
echo -e "   • Reiniciar:     ${YELLOW}docker compose restart${NC}"
echo ""
echo -e "${YELLOW}⚠️  Nota sobre certificados auto-assinados:${NC}"
echo -e "${YELLOW}   O navegador mostrará um aviso de segurança.${NC}"
echo -e "${YELLOW}   Clique em 'Avançado' → 'Prosseguir para node-nginx.local' para continuar.${NC}"
echo ""
echo -e "${BLUE}🔒 Configurações de segurança implementadas:${NC}"
echo -e "   • Certificados SSL/TLS com múltiplos domínios"
echo -e "   • Redirecionamento automático HTTP → HTTPS"
echo -e "   • Headers de segurança (HSTS, CSP, X-Frame-Options, etc.)"
echo -e "   • Protocolos TLS 1.2 e 1.3 apenas"
echo -e "   • Compressão gzip habilitada" 