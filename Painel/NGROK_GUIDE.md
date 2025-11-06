# 🔄 Guia de Atualização do Domínio Ngrok

O ngrok gera um novo domínio toda vez que você reinicia. Este guia mostra como atualizar rapidamente.

## 🚀 Método Rápido (Recomendado)

Quando o ngrok gerar um novo domínio, execute:

```powershell
.\start_dev.ps1 https://SEU-NOVO-DOMINIO.ngrok-free.app
```

Este script irá:
- ✅ Atualizar `.env` (APP_URL e ASSET_URL)
- ✅ Atualizar `lib/utils/app_constants.dart`
- ✅ Limpar cache do Laravel
- ✅ Exibir próximos passos

## 📝 Método Manual

Se preferir atualizar manualmente:

```bash
php update_ngrok_domain.php https://SEU-NOVO-DOMINIO.ngrok-free.app
```

## 🔧 Configuração Inicial

### 1. Iniciar Ngrok
```bash
ngrok http 8000
```

Copie o domínio gerado (ex: `https://abc123.ngrok-free.app`)

### 2. Iniciar Laravel
```bash
php artisan serve --host=127.0.0.1 --port=8000
```

### 3. Atualizar Domínio
```powershell
.\start_dev.ps1 https://abc123.ngrok-free.app
```

### 4. Gerar Pagamento de Teste
```bash
php tmp_pix_create.php
```

## 📍 Arquivos Atualizados Automaticamente

- `Painel/.env` → APP_URL e ASSET_URL
- `lib/utils/app_constants.dart` → baseUrl

## 💡 Dica: Ngrok com Domínio Fixo

Para evitar mudanças constantes, considere:

1. **Conta paga do Ngrok**: Permite domínio fixo personalizado
2. **Ngrok com authtoken**: Execute uma vez:
   ```bash
   ngrok config add-authtoken SEU_TOKEN
   ngrok http --domain=seu-dominio-fixo.ngrok-free.app 8000
   ```

## 🐛 Resolução de Problemas

### Erro 400 ao abrir pagamento
- ✅ Verifique se o `access_token` do Mercado Pago está configurado no `.env`
- ✅ Execute: `php artisan config:clear`

### ERR_NGROK_8012
- ✅ Certifique-se que o servidor Laravel está rodando na porta 8000
- ✅ Execute: `php artisan serve --host=127.0.0.1 --port=8000`

### Webhook não recebe notificações
- ✅ Configure no Mercado Pago: `https://SEU-DOMINIO.ngrok-free.app/payment/mercadopago_pix/webhook`
- ✅ Verifique os logs: `Get-Content storage/logs/laravel.log -Tail 50`

## 📚 Scripts Úteis

| Script | Descrição |
|--------|-----------|
| `start_dev.ps1` | Inicializa ambiente com novo domínio |
| `update_ngrok_domain.php` | Atualiza apenas o domínio |
| `tmp_pix_create.php` | Gera pagamento de teste |
| `tmp_check_payment.php` | Verifica status de pagamento |
| `tmp_setup_mp_pix.php` | Diagnóstico da configuração MP |
