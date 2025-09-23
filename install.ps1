# ##############################################################
#       Windows Winget Kurulum Scripti (TR, Seçmeli)           #
# ##############################################################

# UTF-8 çıktı ve Türkçe karakter desteği
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- MESAJ FONKSİYONLARI ---
function Yaz-OK($mesaj) { Write-Host "✓ $mesaj" -ForegroundColor Green }
function Yaz-HATA($mesaj) { Write-Host "✗ $mesaj" -ForegroundColor Red }
function Yaz-BILGI($mesaj) { Write-Host "ℹ $mesaj" -ForegroundColor Cyan }
function Yaz-UYARI($mesaj) { Write-Host "! $mesaj" -ForegroundColor Yellow }

# --- BAŞLANGIÇ MESAJI ---
Yaz-BILGI "====================================================================="
Yaz-OK "install.ps1 çalışıyor"
Yaz-BILGI "Windows Üzerinde Winget ile Program Yükleme Scripti"
Yaz-UYARI "Bu script, Windows işletim sisteminde Winget paket yöneticisini"
Yaz-UYARI "kullanarak kullanıcı tarafından seçilen uygulamaları yükler."
Yaz-UYARI "Kategori bazlı listeleme yapar."
Yaz-UYARI "Seçilen uygulamayı yükleme işlemi gerçekleştirir."
Yaz-BILGI "====================================================================="
Yaz-HATA "####################### Prepared by SMHKRTLMS #######################"
Yaz-BILGI "====================================================================="
Write-Host ""

# --- YÖNETİCİ KONTROLÜ ---
# Script'in yönetici haklarıyla çalışıp çalışmadığını kontrol eder.
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Yaz-HATA "Bu script'i çalıştırmak için yönetici hakları gereklidir."
    Yaz-UYARI "Lütfen PowerShell'i sağ tıklayıp 'Yönetici olarak çalıştır' seçeneğiyle yeniden başlatın."
    Start-Sleep -Seconds 5
    exit
}

# --- PAKET LİSTELERİ ---
# Her paketin adı (menü için) ve ID'si (kurulum için) olan bir hash table yapısı kullanıldı.
$systemUtils = @(
    @{Name = "neofetch-win"; Id = "nepnep.neofetch-win"},
	@{Name = "CPU-Z"; Id = "CPUID.CPU-Z"},
	@{Name = "CPU-Z"; Id = "TechPowerUp.GPU-Z"},
    @{Name = "CrystalDiskMark"; Id = "CrystalDewWorld.CrystalDiskMark"},
    @{Name = "CrystalDiskInfo"; Id = "CrystalDewWorld.CrystalDiskInfo"},
	@{Name = "HWInfo"; Id = "HWInfo.HWInfo"},
	@{Name = "Speccy"; Id = "Piriform.Speccy"},
	@{Name = "WinDirStat"; Id = "WinDirStat.WinDirStat"},
	@{Name = "PowerToys"; Id = "Microsoft.PowerToys"},
	@{Name = "Process Explorer"; Id = "Microsoft.Sysinternals.ProcessExplorer"},
	@{Name = "Process Monitor"; Id = "Microsoft.Sysinternals.ProcessMonitor"},
	@{Name = "PowerShell 7+"; Id = "Microsoft.Powershell"},
    @{Name = "GNU Wget2"; Id = "GNU.Wget2"},
    @{Name = "Git"; Id = "Git.Git"},
    @{Name = "WinRAR"; Id = "RARLab.WinRAR"},
    @{Name = "7zip"; Id = "7zip.7zip"},
    @{Name = "Vim"; Id = "Vim.Vim"},
    @{Name = "Neovim"; Id = "Neovim.Neovim"},    
    @{Name = "ShareX"; Id = "ShareX.ShareX"},
    @{Name = "BleachBit"; Id = "BleachBit.BleachBit"},
	@{Name = "GlassWire"; Id = "GlassWire.GlassWire"},
    @{Name = "Malwarebytes"; Id = "Malwarebytes.Malwarebytes"}
)
$apps = @(
	@{Name = "TeamViewer"; Id = "TeamViewer.TeamViewer"},	
    @{Name = "Thunderbird"; Id = "Mozilla.Thunderbird"},
	@{Name = "OBS Studio"; Id = "OBSProject.OBSStudio"},
	@{Name = "f.lux"; Id = "Flux.Flux"},
	@{Name = "Paint.NET"; Id = "dotPDN.Paint.NET"},
	@{Name = "Notion"; Id = "Notion.Notion"},
	@{Name = "Bitwarden"; Id = "Bitwarden.Bitwarden"},
    @{Name = "Audacity"; Id = "Audacity.Audacity"},
    @{Name = "darktable"; Id = "darktable.darktable"},    
    @{Name = "GIMP"; Id = "GIMP.GIMP"},
    @{Name = "JDownloader"; Id = "JDownloader.JDownloader"},
    @{Name = "KDE Connect"; Id = "KDE.KDEConnect"},
    @{Name = "KeePassXC"; Id = "KeePassXCTeam.KeePassXC"},
    @{Name = "Gpg4win"; Id = "GnuPG.Gpg4win"},
	@{Name = "WPS Office"; Id = "Kingsoft.WPSOffice"},
    @{Name = "LibreOffice"; Id = "TheDocumentFoundation.LibreOffice"},
	@{Name = "LibreCAD"; Id = "LibreCAD.LibreCAD"},
    @{Name = "LocalSend"; Id = "TienDoNam.LocalSend"},
    @{Name = "lossless-cut"; Id = "mifi.lossless-cut"},
    @{Name = "ExifCleaner"; Id = "ExifCleaner.ExifCleaner"},  
    @{Name = "Obsidian"; Id = "Obsidian.Obsidian"},
    @{Name = "scrcpy"; Id = "Genymobile.scrcpy"},
    @{Name = "Stremio"; Id = "Stremio.Stremio"},
    @{Name = "yt-dlp"; Id = "yt-dlp.yt-dlp"},
    @{Name = "balenaEtcher"; Id = "balenaEtcher.balenaEtcher"},
    @{Name = "Rufus"; Id = "Rufus.Rufus"},
    @{Name = "PeaZip"; Id = "PeaZip.PeaZip"}
)
$browsers = @(
	@{Name = "Google Chrome"; Id = "Google.Chrome"},
    @{Name = "Firefox"; Id = "Mozilla.Firefox"},
	@{Name = "Opera"; Id = "Opera.Opera"},
	@{Name = "Opera GX"; Id = "Opera.OperaGX"},
    @{Name = "Brave"; Id = "Brave.Brave"},
    @{Name = "Yandex Browser"; Id = "Yandex.Browser"},
	@{Name = "Microsoft Edge"; Id = "Microsoft.Edge"},
    @{Name = "Tor Browser"; Id = "TorProject.TorBrowser"}
    
)
$communication = @( 
    @{Name = "WhatsApp"; Id = "9NKSQGP7F2NH"}, # Özel Microsoft Store ID'si
    @{Name = "Telegram"; Id = "Telegram.TelegramDesktop"},
	@{Name = "Discord"; Id = "Discord.Discord"},
	@{Name = "Signal"; Id = "Signal.Signal"},
	@{Name = "Microsoft Teams"; Id = "Microsoft.Teams"},
    @{Name = "Skype"; Id = "Microsoft.Skype"},
    @{Name = "Zoom"; Id = "Zoom.Zoom"}
)
$media = @(
    @{Name = "VLC"; Id = "VideoLAN.VLC"},
	@{Name = "Kodi"; Id = "Kodi.Kodi"},
    @{Name = "Spotify"; Id = "9NCBCSZSJRSB"}, # Özel Microsoft Store ID'si
    @{Name = "Deezer"; Id = "Deezer.Deezer"},
	@{Name = "Apple Music"; Id = "9PFHDD62MXS1"}, # Özel Microsoft Store ID'si
	@{Name = "Winamp"; Id = "Winamp.Winamp"}
)
$devtools = @(
    @{Name = "VirtualBox"; Id = "Oracle.VirtualBox"},
	@{Name = "VMware Workstation"; Id = "VMware.WorkstationPro"},
	@{Name = "XAMPP 8.1"; Id = "ApacheFriends.Xampp.8.1"},
    @{Name = "XAMPP 8.2"; Id = "ApacheFriends.Xampp.8.2"},
    @{Name = "Laragon"; Id = "LeNgocKhoa.Laragon"},
	@{Name = "Docker Desktop"; Id = "Docker.DockerDesktop"},
	@{Name = "VS Code"; Id = "Microsoft.VisualStudioCode"},
    @{Name = "Notepad++"; Id = "Notepad++.Notepad++"},
    @{Name = "Postman"; Id = "Postman.Postman"},
    @{Name = "Python 3"; Id = "Python.Python.3"},
    @{Name = "Node.js"; Id = "NodeJS.NodeJS"},
    @{Name = "Everything"; Id = "Everything.Everything"},   
    @{Name = "PuTTY"; Id = "PuTTY.PuTTY"},
    @{Name = "Termius"; Id = "Termius.Termius"},
    @{Name = "WinSCP"; Id = "WinSCP.WinSCP"}
)
$cloud = @(
    @{Name = "OneDrive"; Id = "Microsoft.OneDrive"},
	@{Name = "Dropbox"; Id = "Dropbox.Dropbox"},
    @{Name = "Google Drive"; Id = "Google.Drive"},
    @{Name = "Yandex Disk"; Id = "Yandex.Disk"},
    @{Name = "iCloud"; Id = "Apple.iCloud"},
    @{Name = "Samsung Cloud"; Id = "9NFWHCHM52HQ"} # Özel Microsoft Store ID'si
)
$games = @(
    @{Name = "Steam"; Id = "Steam.Steam"},
    @{Name = "Epic Games"; Id = "EpicGames.EpicGamesLauncher"},
	@{Name = "Origin (EA)"; Id = "ElectronicArts.Origin"},
	@{Name = "Battle.net (Blizzard)"; Id = "Blizzard.BattleNet"},
	@{Name = "Ubisoft Connect"; Id = "Ubisoft.Uplay"},
    @{Name = "GOG Galaxy"; Id = "GOG.GOGGalaxy"}
)
$adobe = @(
    @{Name = "Adobe Acrobat Reader DC"; Id = "XPDP273C0XHQH2"}, # Özel Microsoft Store ID'si
    @{Name = "Adobe Acrobat Reader (32-bit)"; Id = "Adobe.Acrobat.Reader.32-bit"},
    @{Name = "Adobe Acrobat Reader (64-bit)"; Id = "Adobe.Acrobat.Reader.64-bit"},
    @{Name = "Adobe Creative Cloud"; Id = "Adobe.CreativeCloud"},
    @{Name = "Adobe Express"; Id = "9P94LH3Q1CP5"}, # Özel Microsoft Store ID'si
    @{Name = "Adobe Photoshop"; Id = "XPFD4T9N395QN6"}, # Özel Microsoft Store ID'si
    @{Name = "Adobe Photoshop Express"; Id = "9WZDNCRFJ27N"}, # Özel Microsoft Store ID'si
    @{Name = "Adobe Lightroom"; Id = "XPDP264X2DK8NB"} # Özel Microsoft Store ID'si
)

# --- WINGET KONTROLÜ ---
try {
    Get-Command "winget" -ErrorAction Stop | Out-Null
    Yaz-OK "Winget kullanılabilir."
}
catch {
    Yaz-HATA "Winget yüklü değil ya da PATH değişkeninde yok."
    Yaz-UYARI "Devam etmek için Microsoft Store’dan 'App Installer' yükleyin."
    exit 1
}

# --- KAYNAK GÜNCELLEME ---
Yaz-BILGI "Winget kaynakları güncelleniyor..."
winget source update

# --- KURULU PAKET KONTROLÜ ---
# Paketin kurulu olup olmadığını kontrol eder.
function Is-PackageInstalled($packageId) {
    try {
        # winget list komutunu çalıştırır ve çıktıyı bir değişkende toplar.
        # Hata mesajları da dahil olmak üzere tüm çıktıyı yakalarız.
        $wingetOutput = winget list --id $packageId 2>&1 | Out-String
        
        # Çıktıda paketin ID'sini ve "No installed package found"
        # mesajının OLMADIĞINI kontrol ederiz.
        return ($wingetOutput -like "*$packageId*" -and -not ($wingetOutput -like "*No installed package found*"))
    } catch {
        # Herhangi bir hata durumunda (örneğin winget yoksa) kurulu değildir diye kabul ederiz.
        return $false
    }
}

# --- KURULUM FONKSİYONU ---
function Kategori-Kur($kategoriAdi, $paketler) {
    Yaz-BILGI ">>> $kategoriAdi kategorisi için programları seçin (virgül ile numara yazabilirsiniz):"
    for ($i=0; $i -lt $paketler.Count; $i++) {
        Write-Host (" [{0}] {1}" -f ($i+1), $paketler[$i].Name)
    }
    $secim = Read-Host "Seçiminiz (örn: 1,3,5)"
    $secimler = $secim -split ","

    # Yönetici bağlamında yüklenemeyen programlar için özel liste
    $nonAdminPackages = @("9NKSQGP7F2NH")

    foreach ($s in $secimler) {
        $trimmed = $s.Trim()
        if ($trimmed -match '^\d+$' -and [int]$trimmed -ge 1 -and [int]$trimmed -le $paketler.Count) {
            $pkg = $paketler[[int]$trimmed - 1]
            
            # Kurulumdan önce paketin zaten kurulu olup olmadığını kontrol et
            if (Is-PackageInstalled -packageId $pkg.Id) {
                 Yaz-OK "$($pkg.Name) zaten kurulu. Atlanıyor."
                 continue
            }
            
            Yaz-UYARI "--- Yükleniyor: $($pkg.Name) ---"

            # Eğer paket yönetici bağlamı hatası veriyorsa, otomatik olarak yeni bir pencerede çalıştır
            if ($nonAdminPackages -contains $pkg.Id) {
                Yaz-UYARI "Bu program yönetici yetkisiyle yüklenemiyor. Otomatik olarak yönetici olmayan bir pencerede yükleniyor..."
                Start-Process powershell -ArgumentList "winget install --id $($pkg.Id) --accept-package-agreements --accept-source-agreements --scope user"
                Yaz-OK "Yükleme işlemi yeni bir pencerede başlatıldı. Lütfen takip edin."
                Start-Sleep -Seconds 5
            } else {
                # Standart yükleme
                winget install --id $pkg.Id --accept-package-agreements --accept-source-agreements
            }
        } else {
            Yaz-HATA "Geçersiz seçim: $trimmed"
        }
    }
}

# --- KATEGORİLER VE DÖNGÜ ---
$kategoriler = @(
    @{ Ad = "Sistem & Araçlar"; Paketler = $systemUtils }
    @{ Ad = "Çeşitli Programlar"; Paketler = $apps }
    @{ Ad = "Web Tarayıcılar"; Paketler = $browsers }
    @{ Ad = "İletişim & Medya"; Paketler = $communication }
    @{ Ad = "Medya Oynatıcılar"; Paketler = $media }
    @{ Ad = "Geliştirme Araçları"; Paketler = $devtools }
    @{ Ad = "Bulut Depolama"; Paketler = $cloud }
    @{ Ad = "Oyunlar"; Paketler = $games }
    @{ Ad = "Adobe"; Paketler = $adobe }
)

while ($true) {
    Write-Host ""
    Yaz-BILGI "Kurulum için kategori seçin (virgül ile birden fazla seçebilirsiniz):"
    for ($i = 0; $i -lt $kategoriler.Count; $i++) {
        Write-Host " $($i + 1)) $($kategoriler[$i].Ad)"
    }
    Write-Host " 0) Tüm Kategoriler"
    Write-Host " $($kategoriler.Count + 1)) Çıkış"

    $secim = Read-Host "Seçiminiz"
    if ($secim -eq "0") {
        foreach ($kategori in $kategoriler) {
            Kategori-Kur $kategori.Ad $kategori.Paketler
        }
    } elseif ($secim -eq "$($kategoriler.Count + 1)") {
        Yaz-BILGI "Script sonlandırılıyor..."
        Start-Sleep -Seconds 2
        break
    } else {
        $secimler = $secim -split ","
        foreach ($s in $secimler) {
            $trimmed = $s.Trim()
            if ($trimmed -match '^\d+$' -and [int]$trimmed -ge 1 -and [int]$trimmed -le $kategoriler.Count) {
                $kategori = $kategoriler[[int]$trimmed - 1]
                Kategori-Kur $kategori.Ad $kategori.Paketler
            } else {
                Yaz-HATA "Geçersiz seçim: $trimmed"
            }
        }
    }

    Yaz-OK "Seçilen kategoriler işlendi, menüye dönülüyor."
    Start-Sleep -Seconds 1
}
