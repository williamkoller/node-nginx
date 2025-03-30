# 🔐 Node.js + Nginx com HTTPS

Este projeto demonstra como configurar uma aplicação Node.js com Nginx como proxy reverso, utilizando HTTPS com certificado autoassinado em ambiente local.

---

## 📁 Estrutura

```
node-nginx/
├── certs/                  # Certificados autoassinados
│   ├── cert.pem
│   ├── key.pem
│   └── openssl-san.cnf
│
├── nginx/
│   └── default.conf        # Configuração do Nginx
│
├── src/
│   └── app.js              # Aplicação Node.js com Express
│
├── Dockerfile              # Dockerfile do app Node
├── docker-compose.yml      # Orquestra Node + Nginx
├── generate-certificate.sh # Script para gerar certificados
├── package.json
└── README.md
```

---

## 🚀 Como executar localmente (com certificado autoassinado)

### 1. Gere o certificado

```bash
chmod +x generate-certificate.sh
./generate-certificate.sh
```

> Isso criará `cert.pem` e `key.pem` em `./certs`, com suporte a SAN (Subject Alternative Name) para evitar erros modernos em navegadores.

---

### 2. Suba os containers

```bash
docker-compose up --build
```

A aplicação estará disponível em:

- 🔒 HTTPS: `https://example.com`

> ⚠️ Adicione o domínio ao seu `/etc/hosts`:
>
> ```
> 127.0.0.1 example.com
> ```

---

## 🔐 Acesso HTTPS

Você verá um aviso de "Não seguro" no navegador, pois o certificado é autoassinado. Clique em **"Avançado" > "Prosseguir para example.com"** para continuar.

---

## ✅ Produção com Let's Encrypt

> Certifique-se de:
> - Ter um domínio real (ex: `meudominio.com`)
> - DNS do domínio apontado para seu servidor
> - Portas 80 e 443 abertas

### 1. Instale o Certbot

```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

### 2. Gere o certificado válido

```bash
sudo certbot --nginx -d meudominio.com -d www.meudominio.com
```

Certbot irá editar o `default.conf` automaticamente com HTTPS.

---

## 🔁 Renovação automática

Já configurado pelo Certbot com `cron` ou `systemd`. Para testar:

```bash
sudo certbot renew --dry-run
```

---

## 🛡 Segurança adicional

- ✅ Headers seguros configurados no Nginx (`X-Frame-Options`, `X-XSS-Protection`, etc.)
- ✅ HTTPS com TLSv1.2 e TLSv1.3
- ✅ Reverse proxy com `proxy_set_header` para IP real e protocolo original

---

## 👨‍💻 Autor

Feito com ❤️ por William Koller
