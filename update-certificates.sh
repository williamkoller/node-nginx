#!/bin/bash

set -e

echo "🔐 Atualizando certificados SSL com todos os domínios..."
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Gerar certificados com todos os domínios
echo -e "${BLUE}📜 Gerando certificados para todos os domínios...${NC}"
mkcert -key-file certs/key.pem -cert-file certs/cert.pem \
    node-nginx.local \
    node-nginx.com \
    localhost \
    127.0.0.1 \
    ::1

echo ""
echo -e "${BLUE}🌐 Configurando /etc/hosts...${NC}"

# Verificar e adicionar node-nginx.local
if ! grep -q "node-nginx.local" /etc/hosts 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Adicionando node-nginx.local ao /etc/hosts (requer sudo)${NC}"
    echo "127.0.0.1 node-nginx.local" | sudo tee -a /etc/hosts >/dev/null
    echo -e "${GREEN}✅ node-nginx.local adicionado ao /etc/hosts${NC}"
else
    echo -e "${GREEN}✅ node-nginx.local já existe no /etc/hosts${NC}"
fi

# Verificar e adicionar node-nginx.com
if ! grep -q "node-nginx.com" /etc/hosts 2>/dev/null; then
    echo -e "${YELLOW}⚠️  Adicionando node-nginx.com ao /etc/hosts (requer sudo)${NC}"
    echo "127.0.0.1 node-nginx.com" | sudo tee -a /etc/hosts >/dev/null
    echo -e "${GREEN}✅ node-nginx.com adicionado ao /etc/hosts${NC}"
else
    echo -e "${GREEN}✅ node-nginx.com já existe no /etc/hosts${NC}"
fi

# Reiniciar containers para carregar novos certificados
echo ""
echo -e "${BLUE}🔄 Reiniciando containers...${NC}"
docker compose restart

echo ""
echo -e "${GREEN}🎉 Certificados atualizados com sucesso!${NC}"
echo ""
echo -e "${BLUE}📱 Domínios disponíveis:${NC}"
echo -e "   • ${GREEN}https://node-nginx.local${NC}"
echo -e "   • ${GREEN}https://node-nginx.com${NC}"
echo -e "   • ${GREEN}https://localhost${NC}"
echo ""
echo -e "${BLUE}📋 Certificado válido para:${NC}"
echo -e "   - node-nginx.local"
echo -e "   - node-nginx.com"
echo -e "   - localhost"
echo -e "   - 127.0.0.1"
echo -e "   - ::1"
echo ""
echo -e "${YELLOW}💡 Lembre-se: Reinicie o navegador se ainda aparecer aviso de segurança!${NC}" 