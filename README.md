# Maybe Finance - Docker Setup

[![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)](https://www.docker.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-Latest-dc382d?logo=redis)](https://redis.io/)

Bu repository, [Maybe Finance](https://github.com/maybe-finance/maybe) uygulamasını Docker Compose ile çalıştırmak için gerekli dosyaları içerir. Maybe Finance, kişisel finans yönetimi için açık kaynak bir uygulamadır.

## 📁 Dosyalar

- `compose.yml` - Docker Compose konfigürasyon dosyası
- `.env.example` - Örnek çevre değişkenleri dosyası
- `manage.ps1` - PowerShell yönetim scripti
- `README.md` - Bu dosya

## Gereksinimler

1. **Docker Desktop** yüklü olmalı
   - [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) indirin ve kurun
   - Docker servisinin çalıştığından emin olun

2. **Test için:** Terminal'de aşağıdaki komutu çalıştırın:
   ```powershell
   docker run hello-world
   ```

## 🚀 Hızlı Başlangıç

### 1. Repository'yi Klonlayın
```bash
git clone https://github.com/bymcs/maybe-finance-docker.git
cd maybe-finance-docker
```

### 2. Çevre Değişkenlerini Ayarlayın
```bash
# .env.example dosyasını kopyalayın
cp .env.example .env

# .env dosyasını düzenleyin ve SECRET_KEY_BASE oluşturun
# Windows için:
openssl rand -hex 64
```

### 3. Uygulamayı Başlatın

**PowerShell Script ile (Önerilen):**
```powershell
.\manage.ps1 start
```

**Veya Manuel olarak:**
```powershell
docker compose up -d
```

### 4. Uygulamaya Erişim

🌐 Tarayıcınızda: [http://localhost:3000](http://localhost:3000)

## ✨ Özellikler

- 🐳 **Docker Compose** ile kolay kurulum
- 📊 **PostgreSQL 16** veritabanı
- ⚡ **Redis** cache desteği
- 🔄 **Sidekiq** arka plan işleri
- 💻 **PowerShell** yönetim scripti
- 🔒 **Güvenli** yapılandırma
- 📝 **Detaylı** dokümantasyon

## 🛠️ Yönetim

### PowerShell Script ile
```powershell
# Durumu kontrol et
.\manage.ps1 status

# Logları gör
.\manage.ps1 logs

# Uygulamayı durdur
.\manage.ps1 stop

# Yeniden başlat
.\manage.ps1 restart

# Güncelle
.\manage.ps1 update

# Yardım
.\manage.ps1 help
```

### Manuel Docker Compose Komutları
```powershell
docker compose ps
```

### Logları Görme
```powershell
docker compose logs
docker compose logs -f  # Canlı log takibi
```

### Uygulamayı Durdurma
```powershell
docker compose down
```

### Uygulamayı Güncelleme
```powershell
docker compose pull
docker compose up -d
```

### Veritabanını Sıfırlama (DİKKAT: Tüm veriler silinir!)
```powershell
docker compose down
docker volume rm maybe-finance_postgres-data
docker compose up -d
```

## Güvenlik Notları

### Üretim Ortamı İçin

Eğer bu uygulamayı internet üzerinden erişilebilir bir sunucuda çalıştıracaksanız:

1. `.env` dosyasında güçlü şifreler kullanın
2. SSL ayarlarını aktif edin:
   ```
   RAILS_FORCE_SSL="true"
   RAILS_ASSUME_SSL="true"
   ```
3. Reverse proxy (nginx, traefik) kullanın
4. Firewall ayarlarını yapın

### OpenAI Entegrasyonu

AI özelliklerini kullanmak için `.env` dosyasında:
```
OPENAI_ACCESS_TOKEN="your-api-key-here"
```

**UYARI:** Bu özellik kullanım başına ücretlidir!

## Sorun Giderme

### Veritabanı Bağlantı Hatası
```powershell
docker compose down
docker volume rm maybe-finance_postgres-data
docker compose up -d
```

### Port Çakışması
`compose.yml` dosyasında port numarasını değiştirin:
```yaml
ports:
  - "3001:3000"  # 3000 yerine 3001 kullan
```

### Konteyner Durumunu Kontrol Etme
```powershell
docker compose ps
docker compose logs db
docker compose logs redis
```

## Servisler

Uygulama şu servisleri içerir:

- **web**: Rails web uygulaması (port 3000)
- **worker**: Arka plan işleri (Sidekiq)
- **db**: PostgreSQL veritabanı
- **redis**: Redis cache/message broker

## Veri Yedekleme

Önemli verilerin yedeğini almak için:
```powershell
docker compose exec db pg_dump -U maybe_user maybe_production > backup.sql
```

Yedeği geri yüklemek için:
```powershell
docker compose exec -T db psql -U maybe_user maybe_production < backup.sql
```

## 📚 Daha Fazla Bilgi

- [Maybe Finance GitHub Repository](https://github.com/maybe-finance/maybe)
- [Docker Documentation](https://docs.docker.com/)
- [Resmi Docker Kılavuzu](https://github.com/maybe-finance/maybe/blob/main/docs/hosting/docker.md)

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

Bu proje [Maybe Finance](https://github.com/maybe-finance/maybe) projesinin Docker konfigürasyonudur. Maybe Finance'ın kendi lisansı geçerlidir.

## ⭐ Bu Projeyi Beğendiyseniz

GitHub'da yıldız vermeyi unutmayın! ⭐
