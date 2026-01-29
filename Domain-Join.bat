@echo off
REM =====================================================
REM Domain Join Script Launcher
REM This batch file bypasses execution policy restrictions
REM =====================================================

echo.
echo ========================================
echo    Domain Join Automation Script
echo    https://github.com/WKVDewantha
echo ========================================
echo.

REM Check for administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo.
    echo Please right-click this file and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

echo Starting Domain Join Process...
echo.

REM Create temporary PowerShell script
echo $domain = 'student.vpa.ac.lk' > %temp%\domain-join-temp.ps1
echo $domainUser = '________@company.ac.lk' >> %temp%\domain-join-temp.ps1
echo $domainPassword = '12345' >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host '   Domain Join Tool' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host '   Domain: student.vpa.ac.lk' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo Write-Host '[1] Computer Name Configuration' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo Write-Host '    Format: VA-ITL2-##N (e.g., VA-ITL2-01N, VA-ITL2-12N)' -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo $computerNumber = Read-Host 'Enter the computer number (e.g., 01, 02, 12, 004)' >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo if ([string]::IsNullOrWhiteSpace($computerNumber)) { >> %temp%\domain-join-temp.ps1
echo     Write-Host 'Error: Computer number cannot be empty!' -ForegroundColor Red >> %temp%\domain-join-temp.ps1
echo     pause >> %temp%\domain-join-temp.ps1
echo     exit >> %temp%\domain-join-temp.ps1
echo } >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo $newComputerName = 'VA-ITL2-' + $computerNumber + 'N' >> %temp%\domain-join-temp.ps1
echo Write-Host '    New computer name will be: ' -NoNewline >> %temp%\domain-join-temp.ps1
echo Write-Host $newComputerName -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host 'Please confirm the settings:' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host 'Computer Name : ' -NoNewline >> %temp%\domain-join-temp.ps1
echo Write-Host $newComputerName -ForegroundColor White >> %temp%\domain-join-temp.ps1
echo Write-Host 'Domain        : ' -NoNewline >> %temp%\domain-join-temp.ps1
echo Write-Host $domain -ForegroundColor White >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo $confirm = Read-Host 'Continue? (Y/N)' >> %temp%\domain-join-temp.ps1
echo if ($confirm -ne 'Y' -and $confirm -ne 'y') { >> %temp%\domain-join-temp.ps1
echo     Write-Host 'Operation cancelled.' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo     pause >> %temp%\domain-join-temp.ps1
echo     exit >> %temp%\domain-join-temp.ps1
echo } >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo Write-Host '[2] Checking Current Computer Name...' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo $currentName = $env:COMPUTERNAME >> %temp%\domain-join-temp.ps1
echo Write-Host "    Current name: $currentName" -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
echo Write-Host "    Target name: $newComputerName" -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo if ($currentName -eq $newComputerName) { >> %temp%\domain-join-temp.ps1
echo     Write-Host '    Computer already has correct name!' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo     Write-Host '' >> %temp%\domain-join-temp.ps1
echo     Write-Host '[3] Joining Domain...' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo     try { >> %temp%\domain-join-temp.ps1
echo         $securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force >> %temp%\domain-join-temp.ps1
echo         $credential = New-Object System.Management.Automation.PSCredential ($domainUser, $securePassword) >> %temp%\domain-join-temp.ps1
echo         Add-Computer -DomainName $domain -Credential $credential -Force -ErrorAction Stop >> %temp%\domain-join-temp.ps1
echo         Write-Host '    SUCCESS! Computer joined to domain' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Computer name: ' -NoNewline >> %temp%\domain-join-temp.ps1
echo         Write-Host $newComputerName -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Domain: ' -NoNewline >> %temp%\domain-join-temp.ps1
echo         Write-Host $domain -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo     } >> %temp%\domain-join-temp.ps1
echo     catch { >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Error: ' -NoNewline -ForegroundColor Red >> %temp%\domain-join-temp.ps1
echo         Write-Host $_.Exception.Message -ForegroundColor Red >> %temp%\domain-join-temp.ps1
echo         Write-Host '' >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Common issues:' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - DNS server not reachable (run Setup-DNS.bat)' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Domain credentials incorrect' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Computer already joined to domain' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Network firewall blocking connection' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         pause >> %temp%\domain-join-temp.ps1
echo         exit >> %temp%\domain-join-temp.ps1
echo     } >> %temp%\domain-join-temp.ps1
echo } else { >> %temp%\domain-join-temp.ps1
echo     Write-Host '    Computer needs to be renamed and joined' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo     Write-Host '' >> %temp%\domain-join-temp.ps1
echo     Write-Host '[3] Renaming and Joining Domain...' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo     Write-Host '    (Both operations will be applied together)' -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
echo     try { >> %temp%\domain-join-temp.ps1
echo         $securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force >> %temp%\domain-join-temp.ps1
echo         $credential = New-Object System.Management.Automation.PSCredential ($domainUser, $securePassword) >> %temp%\domain-join-temp.ps1
echo         Add-Computer -DomainName $domain -NewName $newComputerName -Credential $credential -Force -ErrorAction Stop >> %temp%\domain-join-temp.ps1
echo         Write-Host '    SUCCESS! Computer will be renamed and joined on restart' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo         Write-Host '    New computer name: ' -NoNewline >> %temp%\domain-join-temp.ps1
echo         Write-Host $newComputerName -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Domain: ' -NoNewline >> %temp%\domain-join-temp.ps1
echo         Write-Host $domain -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo     } >> %temp%\domain-join-temp.ps1
echo     catch { >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Error: ' -NoNewline -ForegroundColor Red >> %temp%\domain-join-temp.ps1
echo         Write-Host $_.Exception.Message -ForegroundColor Red >> %temp%\domain-join-temp.ps1
echo         Write-Host '' >> %temp%\domain-join-temp.ps1
echo         Write-Host '    Common issues:' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - DNS server not reachable (run Setup-DNS.bat)' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Domain credentials incorrect' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Computer account already exists in domain' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         Write-Host '    - Network firewall blocking connection' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo         pause >> %temp%\domain-join-temp.ps1
echo         exit >> %temp%\domain-join-temp.ps1
echo     } >> %temp%\domain-join-temp.ps1
echo } >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo. >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo Write-Host '   Configuration Completed!' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo Write-Host '========================================' -ForegroundColor Green >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo Write-Host 'After restart, the computer will have:' -ForegroundColor Cyan >> %temp%\domain-join-temp.ps1
echo Write-Host "  - Computer Name: $newComputerName" -ForegroundColor White >> %temp%\domain-join-temp.ps1
echo Write-Host "  - Full Name: $newComputerName.$domain" -ForegroundColor White >> %temp%\domain-join-temp.ps1
echo Write-Host "  - Domain: $domain" -ForegroundColor White >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo Write-Host 'The computer will restart in 15 seconds...' -ForegroundColor Yellow >> %temp%\domain-join-temp.ps1
echo Write-Host 'Press Ctrl+C to cancel restart' -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
echo Write-Host '' >> %temp%\domain-join-temp.ps1
echo Start-Sleep -Seconds 15 >> %temp%\domain-join-temp.ps1
echo Restart-Computer -Force >> %temp%\domain-join-temp.ps1

REM Run the PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -File %temp%\domain-join-temp.ps1

REM Clean up temporary file
del %temp%\domain-join-temp.ps1

if %errorLevel% neq 0 (
    echo.
    echo Script execution failed!
    pause
)
