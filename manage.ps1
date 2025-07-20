# Maybe Finance Management Script
# Bu script, Maybe Finance uygulamasını yönetmek için kullanılır

param(
    [Parameter(Position=0)]
    [string]$Action = "help"
)

$ComposeFile = "compose.yml"
$ProjectName = "maybe-finance"

function Show-Help {
    Write-Host "Maybe Finance Docker Management Script" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Kullanım: .\manage.ps1 [komut]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Komutlar:" -ForegroundColor Cyan
    Write-Host "  start      - Uygulamayı başlat (arka plan)" -ForegroundColor White
    Write-Host "  stop       - Uygulamayı durdur" -ForegroundColor White
    Write-Host "  restart    - Uygulamayı yeniden başlat" -ForegroundColor White
    Write-Host "  status     - Durum bilgisini göster" -ForegroundColor White
    Write-Host "  logs       - Log'ları göster" -ForegroundColor White
    Write-Host "  update     - Uygulamayı güncelle" -ForegroundColor White
    Write-Host "  reset      - Veritabanını sıfırla (DİKKAT!)" -ForegroundColor Red
    Write-Host "  backup     - Veritabanı yedeği al" -ForegroundColor White
    Write-Host "  open       - Uygulamayı tarayıcıda aç" -ForegroundColor White
    Write-Host "  help       - Bu yardım mesajını göster" -ForegroundColor White
    Write-Host ""
    Write-Host "Örnekler:" -ForegroundColor Cyan
    Write-Host "  .\manage.ps1 start" -ForegroundColor Gray
    Write-Host "  .\manage.ps1 logs" -ForegroundColor Gray
    Write-Host "  .\manage.ps1 status" -ForegroundColor Gray
}

function Test-DockerRunning {
    try {
        docker version | Out-Null
        return $true
    } catch {
        Write-Host "HATA: Docker çalışmıyor. Docker Desktop'ı başlatın." -ForegroundColor Red
        return $false
    }
}

function Start-Application {
    Write-Host "Maybe Finance uygulaması başlatılıyor..." -ForegroundColor Green
    docker compose -f $ComposeFile up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Uygulama başarıyla başlatıldı!" -ForegroundColor Green
        Write-Host "🌐 Uygulama adresi: http://localhost:3000" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Durum kontrolü için: .\manage.ps1 status" -ForegroundColor Yellow
    }
}

function Stop-Application {
    Write-Host "Uygulama durduruluyor..." -ForegroundColor Yellow
    docker compose -f $ComposeFile down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Uygulama başarıyla durduruldu!" -ForegroundColor Green
    }
}

function Restart-Application {
    Write-Host "Uygulama yeniden başlatılıyor..." -ForegroundColor Yellow
    Stop-Application
    Start-Sleep -Seconds 2
    Start-Application
}

function Show-Status {
    Write-Host "Maybe Finance Durum Bilgisi" -ForegroundColor Green
    Write-Host "===========================" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Konteyner Durumu:" -ForegroundColor Cyan
    docker compose -f $ComposeFile ps
    
    Write-Host ""
    Write-Host "Sistem Kaynakları:" -ForegroundColor Cyan
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $(docker compose -f $ComposeFile ps -q)
}

function Show-Logs {
    Write-Host "Son log kayıtları gösteriliyor... (Çıkmak için Ctrl+C)" -ForegroundColor Green
    docker compose -f $ComposeFile logs -f --tail=50
}

function Update-Application {
    Write-Host "Uygulama güncelleniyor..." -ForegroundColor Green
    
    Write-Host "1. Son sürüm indiriliyor..." -ForegroundColor Yellow
    docker compose -f $ComposeFile pull
    
    Write-Host "2. Uygulama yeniden başlatılıyor..." -ForegroundColor Yellow
    docker compose -f $ComposeFile up -d
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Güncelleme tamamlandı!" -ForegroundColor Green
    }
}

function Reset-Database {
    Write-Host "DİKKAT: Bu işlem tüm verileri silecek!" -ForegroundColor Red
    $confirm = Read-Host "Devam etmek istediğinizden emin misiniz? (yes/no)"
    
    if ($confirm -eq "yes") {
        Write-Host "Veritabanı sıfırlanıyor..." -ForegroundColor Yellow
        docker compose -f $ComposeFile down
        docker volume rm "${ProjectName}_postgres-data" -f
        Start-Application
        Write-Host "✓ Veritabanı sıfırlandı!" -ForegroundColor Green
    } else {
        Write-Host "İşlem iptal edildi." -ForegroundColor Yellow
    }
}

function Backup-Database {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "backup_$timestamp.sql"
    
    Write-Host "Veritabanı yedeği alınıyor..." -ForegroundColor Green
    docker compose -f $ComposeFile exec -T db pg_dump -U maybe_user maybe_production > $backupFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Yedek başarıyla alındı: $backupFile" -ForegroundColor Green
    } else {
        Write-Host "✗ Yedek alma başarısız!" -ForegroundColor Red
    }
}

function Open-Application {
    Write-Host "Uygulama tarayıcıda açılıyor..." -ForegroundColor Green
    Start-Process "http://localhost:3000"
}

# Ana script mantığı
if (-not (Test-DockerRunning)) {
    exit 1
}

if (-not (Test-Path $ComposeFile)) {
    Write-Host "HATA: $ComposeFile dosyası bulunamadı!" -ForegroundColor Red
    Write-Host "Bu scripti doğru dizinde çalıştırdığınızdan emin olun." -ForegroundColor Yellow
    exit 1
}

switch ($Action.ToLower()) {
    "start" { Start-Application }
    "stop" { Stop-Application }
    "restart" { Restart-Application }
    "status" { Show-Status }
    "logs" { Show-Logs }
    "update" { Update-Application }
    "reset" { Reset-Database }
    "backup" { Backup-Database }
    "open" { Open-Application }
    "help" { Show-Help }
    default { 
        Write-Host "Bilinmeyen komut: $Action" -ForegroundColor Red
        Write-Host ""
        Show-Help
    }
}
