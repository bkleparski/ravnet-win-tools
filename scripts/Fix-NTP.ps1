#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Fix-NTP — naprawa i konfiguracja Windows Time Service (NTP) na Windows 11
.DESCRIPTION
    Resetuje i rekonfiguruje W32Time, ustawia publiczne serwery NTP pool.ntp.org
    oraz wymusza natychmiastową synchronizację czasu.
.PARAMETER NtpServer
    Lista serwerow NTP oddzielona przecinkami.
    Domyslnie: pool.ntp.org,0.pl.pool.ntp.org,1.pl.pool.ntp.org
.EXAMPLE
    irm go.ebartnet.pl/win | iex
    .\Fix-NTP.ps1
    .\Fix-NTP.ps1 -NtpServer "time.windows.com,pool.ntp.org"
#>

[CmdletBinding()]
param(
    [string]$NtpServer = "pool.ntp.org,0.pl.pool.ntp.org,1.pl.pool.ntp.org"
)

function Write-Step { param([string]$Message); Write-Host "`n[*] $Message" -ForegroundColor Cyan }
function Write-OK   { param([string]$Message); Write-Host "    [OK] $Message" -ForegroundColor Green }
function Write-Fail { param([string]$Message); Write-Host "    [!!] $Message" -ForegroundColor Red }

# 1. STOP
Write-Step "Zatrzymywanie Windows Time Service..."
try {
    Stop-Service -Name "W32Time" -Force -ErrorAction Stop
    Write-OK "Serwis zatrzymany."
} catch {
    Write-Fail "Nie udalo sie zatrzymac serwisu: $($_.Exception.Message)"
}

# 2. REJESTRACJA
Write-Step "Rejestracja W32Time od nowa..."
& w32tm /unregister 2>&1 | Out-Null
& w32tm /register  2>&1 | Out-Null
Write-OK "W32Time zarejestrowany."

# 3. START
Write-Step "Uruchamianie serwisu..."
try {
    Start-Service -Name "W32Time" -ErrorAction Stop
    Set-Service  -Name "W32Time" -StartupType Automatic
    Write-OK "Serwis uruchomiony, tryb: Automatic."
} catch {
    Write-Fail "Blad startu serwisu: $($_.Exception.Message)"
    exit 1
}

# 4. KONFIGURACJA NTP
Write-Step "Konfiguracja serwera NTP: $NtpServer"
& w32tm /config /manualpeerlist:"$NtpServer" /syncfromflags:manual /reliable:YES /update
Write-OK "Serwer NTP ustawiony."

# 5. REJESTR
Write-Step "Wlaczanie automatycznej synchronizacji..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" `
                 -Name "Type" -Value "NTP" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Config" `
                 -Name "AnnounceFlags" -Value 5 -Force
Write-OK "Rejestr zaktualizowany."

# 6. RESYNC
Write-Step "Wymuszanie synchronizacji czasu..."
& w32tm /resync /force
Start-Sleep -Seconds 3

# 7. STATUS
Write-Step "Status synchronizacji:"
& w32tm /query /status 2>&1 | ForEach-Object { Write-Host "    $_" }

Write-Step "Aktualny czas systemowy:"
$os = Get-CimInstance -ClassName Win32_OperatingSystem
Write-OK "Lokalny : $($os.LocalDateTime)"
Write-OK "Strefa  : $(Get-TimeZone | Select-Object -ExpandProperty DisplayName)"

# 8. PEERS
Write-Step "Test peer NTP:"
& w32tm /query /peers 2>&1 | ForEach-Object { Write-Host "    $_" }

Write-Host "`nGotowe." -ForegroundColor Green
