# Node.js + Nginx com SSL/HTTPS

Aplicação Node.js com proxy reverso Nginx e SSL/HTTPS configurado para desenvolvimento local.

## ✅ Status da Implementação

**🔒 Site completamente seguro com certificados SSL confiáveis!**

### 🧪 Testes Realizados com Sucesso:

- ✅ **HTTPS funcionando** - Retorna HTTP/2 200
- ✅ **Certificados confiáveis** - Sem avisos de segurança no navegador
- ✅ **Redirecionamento HTTP → HTTPS** - Retorna 301
- ✅ **Headers de segurança** implementados e ativos
- ✅ **Múltiplos domínios** suportados
- ✅ **Containers rodando** de forma estável
- ✅ **Compressão gzip** ativa
- ✅ **Protocolos TLS 1.2 e 1.3** configurados

## 🔒 Recursos de Segurança

- ✅ **SSL/TLS** com certificados confiáveis (mkcert)
- ✅ **Redirecionamento automático** HTTP → HTTPS
- ✅ **Headers de segurança** (HSTS, CSP, X-Frame-Options, etc.)
- ✅ **Protocolos seguros** TLS 1.2 e 1.3 apenas
- ✅ **Compressão gzip** habilitada
- ✅ **Múltiplos domínios** suportados

## 🚀 Configuração Rápida

### Opção 1: Configuração Completa (Recomendada)

```bash
./setup-ssl.sh
```

### Opção 2: Atualizar Certificados

```bash
./update-certificates.sh
```

## 📱 Como Acessar

Após executar o setup, acesse sua aplicação **sem avisos de segurança**:

- **HTTPS**: https://node-nginx.local ✅
- **HTTPS**: https://node-nginx.com ✅
- **HTTPS**: https://localhost ✅
- **HTTP (redireciona)**: http://node-nginx.local:8080

## 🛠️ Scripts Disponíveis

| Script                    | Descrição                                                                              |
| ------------------------- | -------------------------------------------------------------------------------------- |
| `setup-ssl.sh`            | **Configuração inicial completa** - Instala mkcert, gera certificados, configura hosts |
| `update-certificates.sh`  | **Atualiza certificados** - Regenera certificados para todos os domínios               |
| `generate-certificate.sh` | **Certificados básicos** - Gera certificados auto-assinados simples                    |

### 🔐 Certificados Confiáveis com mkcert

O projeto usa `mkcert` para gerar certificados SSL locais confiáveis:

```bash
# Instalar mkcert (feito automaticamente pelo setup-ssl.sh)
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

# Instalar CA local
mkcert -install

# Gerar certificados para todos os domínios
./update-certificates.sh
```

## 🌐 Domínios Suportados

Todos os domínios abaixo funcionam com HTTPS sem avisos de segurança:

- `node-nginx.local`
- `node-nginx.com`
- `localhost`
- `127.0.0.1`
- `::1` (IPv6)

## 🛡️ Headers de Segurança Implementados

Os seguintes headers de segurança estão ativos:

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self';
```

## 🔧 Comandos Úteis

```bash
# Ver logs de todos os serviços
docker compose logs -f

# Ver logs apenas do Nginx
docker compose logs -f nginx

# Parar todos os containers
docker compose down

# Reiniciar os serviços
docker compose restart

# Verificar status dos containers
docker compose ps

# Testar HTTPS (todos os domínios)
curl -I https://node-nginx.local
curl -I https://node-nginx.com
curl -I https://localhost

# Testar redirecionamento HTTP → HTTPS
curl -I http://node-nginx.local:8080

# Verificar certificados
openssl x509 -in certs/cert.pem -text -noout | grep -A 5 "Subject Alternative Name"
```

## 🏗️ Arquitetura

```
Cliente → HTTP:8080 → [Nginx Redirect] → HTTPS:443 → [SSL/Proxy] → Node.js:3000
```

### Componentes:

- **Node.js**: Aplicação backend na porta 3000
- **Nginx**: Proxy reverso com SSL/TLS nas portas 8080 (HTTP) e 443 (HTTPS)
- **Certificados SSL**: Confiáveis gerados pelo mkcert

## 📋 Portas Utilizadas

| Serviço | Porta | Protocolo | Descrição                   |
| ------- | ----- | --------- | --------------------------- |
| Node.js | 3000  | HTTP      | Aplicação (interno)         |
| Nginx   | 8080  | HTTP      | Redirecionamento para HTTPS |
| Nginx   | 443   | HTTPS     | Acesso seguro principal     |

## 🔐 Configuração SSL

### Certificados Confiáveis:

- **Gerados por**: mkcert (CA local confiável)
- **Válidos até**: 25 de setembro de 2027
- **Sem avisos**: Navegador não mostra avisos de segurança

### Domínios no Certificado:

- `node-nginx.local`
- `node-nginx.com`
- `localhost`
- `127.0.0.1`
- `::1` (IPv6)

### Protocolos SSL/TLS:

- **TLS 1.2** ✅
- **TLS 1.3** ✅
- **HTTP/2** ✅ (Ativo)

## 🛠️ Configuração Manual

Se preferir configurar manualmente:

### 1. Instalar mkcert

```bash
# Baixar e instalar mkcert
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert

# Instalar suporte aos navegadores
sudo apt install libnss3-tools

# Instalar CA local
mkcert -install
```

### 2. Gerar Certificados

```bash
mkcert -key-file certs/key.pem -cert-file certs/cert.pem \
    node-nginx.local \
    node-nginx.com \
    localhost \
    127.0.0.1 \
    ::1
```

### 3. Configurar /etc/hosts

```bash
echo "127.0.0.1 node-nginx.local" | sudo tee -a /etc/hosts
echo "127.0.0.1 node-nginx.com" | sudo tee -a /etc/hosts
```

### 4. Iniciar Containers

```bash
docker compose up -d
```

## 🔍 Troubleshooting

### Ainda aparece aviso de segurança

1. **Reinicie completamente o navegador**
2. **Limpe o cache SSL**: `chrome://net-internals/#hsts`
3. **Teste em janela privada/incógnita**
4. **Verifique se mkcert está instalado**: `mkcert -CAROOT`

### Erro "Porta em uso"

Se a porta 443 estiver em uso:

```bash
# Verificar qual processo está usando a porta
sudo netstat -tlnp | grep :443

# Parar Apache2 se necessário
sudo systemctl stop apache2
```

### Certificado não aceito

```bash
# Verificar se certificado tem todos os domínios
openssl x509 -in certs/cert.pem -text -noout | grep -A 5 "Subject Alternative Name"

# Verificar se mkcert CA está instalada
mkcert -CAROOT
```

### Container não inicia

```bash
# Ver logs detalhados
docker compose logs nginx

# Verificar configuração do Nginx
docker compose exec nginx nginx -t
```

## 💡 Dicas Importantes

### Para Desenvolvimento:

- ✅ Use `mkcert` para certificados confiáveis locais
- ✅ Execute `./update-certificates.sh` para atualizar certificados
- ✅ Reinicie o navegador após instalar mkcert

### Para Produção:

- 🔄 Use Let's Encrypt com Certbot
- 🔄 Configure DNS real para os domínios
- 🔄 Use certificados de CA confiáveis

## 🎯 Próximos Passos

1. **Desenvolvimento**: Tudo pronto! Use os domínios HTTPS sem avisos
2. **Produção**: Migre para Let's Encrypt e domínios reais
3. **CI/CD**: Configure pipelines para deploy automático
