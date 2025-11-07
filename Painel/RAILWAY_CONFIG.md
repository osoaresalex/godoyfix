# Configuração Railway - Fix Asset URLs

## Problema
O Laravel está gerando URLs com `/public/assets/` em vez de `/assets/`

## Solução
Configure a variável de ambiente no Railway:

1. Acesse o Railway Dashboard: https://railway.app
2. Selecione o projeto **godoyfix-production**
3. Vá em **Variables** (ou Settings → Variables)
4. Adicione a seguinte variável:

```
ASSET_URL=https://godoyfix-production.up.railway.app
```

OU (se você tem domínio customizado):

```
ASSET_URL=https://seudominio.com
```

5. Clique em **Deploy** ou espere o redeploy automático
6. Limpe o cache do navegador (Ctrl+Shift+Del) ou use janela anônima

## Alternativa (se não funcionar)
Se ainda não funcionar, adicione também:

```
APP_URL=https://godoyfix-production.up.railway.app
FORCE_HTTPS=true
```

E garanta que não há `PUBLIC_PATH` ou `ASSET_PREFIX` configurados.
