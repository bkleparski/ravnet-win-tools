# Ravnet Win-Tools

Zestaw skryptow PowerShell do naprawy i konfiguracji **Windows 11**, uruchamianych jednym poleceniem.

## Uruchomienie

```powershell
irm go.ebartnet.pl/win | iex
```

> **Wymagane:** terminal PowerShell uruchomiony jako **Administrator**.

---

## Dostepne narzedzia

| Skrypt | Opis |
|---|---|
| `Fix-NTP.ps1` | Naprawa i konfiguracja Windows Time Service (NTP) |

---

## Szczegoly — Fix-NTP

Skrypt wykonuje:
1. Zatrzymanie i ponowna rejestracja serwisu `W32Time`
2. Konfiguracja serwerow NTP: `pool.ntp.org`, `0.pl.pool.ntp.org`, `1.pl.pool.ntp.org`
3. Wymuszenie natychmiastowej synchronizacji
4. Weryfikacja statusu i wyswietlenie aktualnego czasu

### Uzycie standalone

```powershell
# Domyslne serwery NTP
.\scripts\Fix-NTP.ps1

# Wlasne serwery
.\scripts\Fix-NTP.ps1 -NtpServer "time.windows.com,pool.ntp.org"
```

---

## Wymagania

- Windows 10 / 11
- PowerShell 5.1+
- Uprawnienia Administratora

---

## Autor

**Bartek Kleparski** — [ebartnet.pl](https://ebartnet.pl)  
Ravnet Sp. z o.o. — HelpDesk IT

> Projekt rozwijany na potrzeby wewnetrzne i udostepniany publicznie.
