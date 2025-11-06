# Script para iniciar o ambiente de desenvolvimento com ngrok
# Uso: .\start_dev.ps1 https://SEU-DOMINIO.ngrok-free.app

param(
    [Parameter(Mandatory=$true)]
    [string]$NgrokUrl
)

Write-Host "🚀 Iniciando ambiente de desenvolvimento..." -ForegroundColor Cyan
Write-Host ""

# Navegar para o diretório do Painel
$PainelPath = "c:\Users\NT-ETC\Desktop\Demandium v3.3\User app and web\Painel"
Set-Location $PainelPath

# 1. Atualizar domínio ngrok
Write-Host "📝 Atualizando domínio ngrok..." -ForegroundColor Yellow
php update_ngrok_domain.php $NgrokUrl

Write-Host ""
Write-Host "✅ Configuração concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "🔥 O servidor Laravel já deve estar rodando em segundo plano." -ForegroundColor Cyan
Write-Host "   Se não estiver, execute: php artisan serve --host=127.0.0.1 --port=8000" -ForegroundColor Gray
Write-Host ""
Write-Host "💰 Para gerar um pagamento de teste:" -ForegroundColor Cyan
Write-Host "   php tmp_pix_create.php" -ForegroundColor White
Write-Host ""
Write-Host "🔍 Para verificar um pagamento:" -ForegroundColor Cyan
Write-Host "   php tmp_check_payment.php [payment_id]" -ForegroundColor White
Write-Host ""
