#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Ravnet Win-Tools — launcher
    Uruchamiaj przez: irm go.ebartnet.pl/win | iex
#>

$menuItems = @(
    [PSCustomObject]@{ Id = 1; Label = "Fix NTP — naprawa synchronizacji czasu" }
    [PSCustomObject]@{ Id = 0; Label = "Wyjdz" }
)

function Show-Menu {
    Clear-Host
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "   Ravnet Win-Tools dla Windows 11" -ForegroundColor White
    Write-Host "   https://github.com/bkleparski/ravnet-win-tools" -ForegroundColor DarkGray
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    foreach ($item in $menuItems) {
        Write-Host "  [$($item.Id)] $($item.Label)" -ForegroundColor Yellow
    }
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Wybierz opcje"
    switch ($choice) {
        "1" {
            Write-Host "`nPobieram Fix-NTP..." -ForegroundColor Cyan
            $url = "https://raw.githubusercontent.com/bkleparski/ravnet-win-tools/main/scripts/Fix-NTP.ps1"
            Invoke-Expression (Invoke-RestMethod -Uri $url)
            Write-Host "`nNacisnij Enter, aby wrocic do menu..." -ForegroundColor DarkGray
            $null = Read-Host
        }
        "0" { Write-Host "Do zobaczenia!" -ForegroundColor Green }
        default { Write-Host "Nieznana opcja — sprobuj ponownie." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($choice -ne "0")
