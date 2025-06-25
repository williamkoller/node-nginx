# Node.js + Nginx com SSL/HTTPS

Aplicação Node.js com proxy reverso Nginx e SSL/HTTPS configurado para desenvolvimento local.

## ✅ Status da Implementação

**🔒 Site completamente seguro com SSL/HTTPS funcionando!**

### 🧪 Testes Realizados com Sucesso:

- ✅ **HTTPS funcionando** - Retorna HTTP/2 200
- ✅ **Redirecionamento HTTP → HTTPS** - Retorna 301
- ✅ **Headers de segurança** implementados e ativos
- ✅ **Certificados SSL** válidos para todos os domínios
- ✅ **Containers rodando** de forma estável
- ✅ **Compressão gzip** ativa
- ✅ **Protocolos TLS 1.2 e 1.3** configurados

## 🔒 Recursos de Segurança

- ✅ **SSL/TLS** com certificados auto-assinados
- ✅ **Redirecionamento automático** HTTP → HTTPS
- ✅ **Headers de segurança** (HSTS, CSP, X-Frame-Options, etc.)
- ✅ **Protocolos seguros** TLS 1.2 e 1.3 apenas
- ✅ **Compressão gzip** habilitada
- ✅ **Múltiplos domínios** suportados

## 🚀 Configuração Automática

Execute o script de configuração completa:

```bash
./setup-ssl.sh
```

Este script irá:

- Gerar certificados SSL para múltiplos domínios
- Configurar o `/etc/hosts` automaticamente
- Construir e iniciar os containers
- Testar a conectividade SSL/HTTPS

## 📱 Como Acessar

Após executar o setup, acesse sua aplicação:

- **HTTPS (recomendado)**: https://node-nginx.local
- **HTTP (redireciona)**: http://node-nginx.local:8080
- **Localhost HTTPS**: https://localhost

## ⚠️ Certificados Auto-assinados

O navegador mostrará um aviso de segurança para certificados auto-assinados:

1. Clique em **"Avançado"**
2. Clique em **"Prosseguir para node-nginx.local"**
3. A aplicação carregará com SSL/HTTPS ativo

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

# Testar HTTPS
curl -k -I https://node-nginx.local

# Testar redirecionamento HTTP → HTTPS
curl -I http://node-nginx.local:8080
```

## 🏗️ Arquitetura

```
Cliente → HTTP:8080 → [Nginx Redirect] → HTTPS:443 → [SSL/Proxy] → Node.js:3000
```

### Componentes:

- **Node.js**: Aplicação backend na porta 3000
- **Nginx**: Proxy reverso com SSL/TLS nas portas 8080 (HTTP) e 443 (HTTPS)
- **Certificados SSL**: Auto-assinados para desenvolvimento local

## 📋 Portas Utilizadas

| Serviço | Porta | Protocolo | Descrição                   |
| ------- | ----- | --------- | --------------------------- |
| Node.js | 3000  | HTTP      | Aplicação (interno)         |
| Nginx   | 8080  | HTTP      | Redirecionamento para HTTPS |
| Nginx   | 443   | HTTPS     | Acesso seguro principal     |

## 🔐 Configuração SSL

### Domínios no Certificado:

- `node-nginx.local`
- `localhost`
- `node-nginx.com`
- `127.0.0.1`

### Headers de Segurança Implementados:

- `Strict-Transport-Security`
- `X-Content-Type-Options`
- `X-Frame-Options`
- `X-XSS-Protection`
- `Referrer-Policy`
- `Content-Security-Policy`

### Protocolos SSL/TLS:

- **TLS 1.2** ✅
- **TLS 1.3** ✅
- **HTTP/2** ✅ (Ativo)

## 🛠️ Configuração Manual

Se preferir configurar manualmente:

### 1. Gerar Certificados SSL

```bash
chmod +x generate-certificate.sh
./generate-certificate.sh
```

### 2. Configurar /etc/hosts

```bash
echo "127.0.0.1 node-nginx.local" | sudo tee -a /etc/hosts
```

### 3. Iniciar Containers

```bash
docker compose up -d
```

## 🔍 Troubleshooting

### Erro "Porta em uso"

Se a porta 443 estiver em uso:

```bash
# Verificar qual processo está usando a porta
sudo netstat -tlnp | grep :443

# Parar Apache2 se necessário
sudo systemctl stop apache2
```

### Certificado não aceito

- Verifique se o domínio no navegador corresponde ao certificado
- Certifique-se de que `/etc/hosts` está configurado corretamente

### Container não inicia

```bash
# Ver logs detalhados
docker compose logs nginx

# Verificar configuração do Nginx
docker compose exec nginx nginx -t
```

### Verificar se SSL está funcionando

```bash
# Testar conectividade HTTPS
curl -k -s https://node-nginx.local

# Verificar certificado
openssl s_client -connect node-nginx.local:443 -servername node-nginx.local
```

## 📚 Tecnologias

- **Node.js 23.8** (Alpine)
- **Nginx** (Alpine)
- **Docker & Docker Compose**
- **OpenSSL** para certificados
- **SSL/TLS 1.2 e 1.3**

---

## 🎯 Próximos Passos

Para produção, considere:

- Certificados SSL válidos (Let's Encrypt)
- Load balancing
- Monitoramento com OpenTelemetry
- Rate limiting
- WAF (Web Application Firewall)

---

## 🚀 Início Rápido

1. **Execute o setup automático:**

   ```bash
   ./setup-ssl.sh
   ```

2. **Acesse sua aplicação segura:**

   ```
   https://node-nginx.local
   ```

3. **Aceite o certificado auto-assinado no navegador**

4. **Pronto! Sua aplicação está rodando com HTTPS! 🔒**
