#!/bin/bash
# Script completo para reiniciar o ambiente após ngrok parar
# Uso: ./script.sh NOVO_DOMINIO_NGROK

NGROK_URL=$1
PAINEL_PATH="c:/Users/NT-ETC/Desktop/Demandium v3.3/User app and web/Painel"

echo "🚀 Godoy Resolve - Ambiente de Desenvolvimento"
echo "============================================="
echo ""

# Verificar se o ngrok URL foi fornecido
if [ -z "$NGROK_URL" ]; then
    echo "⚠️  Nenhum domínio ngrok fornecido."
    echo ""
    echo "📋 Instruções:"
    echo "   1. Inicie o ngrok: ngrok http 8000"
    echo "   2. Copie o domínio gerado (ex: https://abc123.ngrok-free.app)"
    echo "   3. Execute: ./script.sh https://SEU-DOMINIO.ngrok-free.app"
    echo ""
    
    read -p "Cole o domínio ngrok aqui (ou pressione Enter para pular): " NGROK_URL
    
    if [ -z "$NGROK_URL" ]; then
        echo ""
        echo "⚠️  Pulando atualização do domínio..."
    fi
fi

# Se temos um URL do ngrok, atualizar
if [ -n "$NGROK_URL" ]; then
    echo "🔄 Atualizando domínio ngrok..."
    php update_ngrok_domain.php "$NGROK_URL"
    echo ""
fi

# Verificar se o servidor Laravel está rodando
echo "🔍 Verificando servidor Laravel..."
if pgrep -f "artisan serve" > /dev/null; then
    echo "✅ Servidor Laravel já está rodando"
else
    echo "⚠️  Servidor Laravel não está rodando. Iniciando..."
    php artisan serve --host=127.0.0.1 --port=8000 &
    sleep 2
    echo "✅ Servidor Laravel iniciado!"
fi

echo ""
echo "✅ Ambiente pronto!"
echo ""
echo "📝 Comandos úteis:"
echo "   Gerar pagamento PIX:  php tmp_pix_create.php"
echo "   Verificar pagamento:  php tmp_check_payment.php [id]"
echo "   Verificar config MP:  php tmp_setup_mp_pix.php"
echo "   Configurar token MP:  php tmp_configure_mp_token.php"
echo ""
(crontab -l | grep -v "/usr/local/bin/php555 /Applications/MAMP/htdocs/Demandium-Admin/artisan email:free-trial-end-mail") | crontab -
(crontab -l; echo "0 0 * * * /usr/local/bin/php555 /Applications/MAMP/htdocs/Demandium-Admin/artisan email:free-trial-end-mail") | crontab -
