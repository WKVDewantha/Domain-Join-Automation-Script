@echo off
REM =====================================================
REM DNS Configuration Script
REM Sets DNS server for domain connectivity
REM =====================================================

echo.
echo ========================================
echo    DNS Configuration Automation Tool
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

echo This script will configure your DNS settings for domain joining.
echo.
echo Default DNS Server: 192.168.0.10
echo DNS Suffix: company.ac.lk
echo.

set /p DNS_SERVER="Enter DNS server IP (or press Enter for 192.168.0.10): "
if "%DNS_SERVER%"=="" set DNS_SERVER=192.168.0.10 

echo.
echo Configuring DNS...
echo.

REM Create temporary PowerShell script
echo $dnsServer = '%DNS_SERVER%' > %temp%\dns-config-temp.ps1
echo $dnsSuffix = 'company.ac.lk' >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host 'Finding active network adapter...' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo $adapter = Get-NetAdapter ^| Where-Object {$_.Status -eq 'Up'} ^| Select-Object -First 1 >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo if ($null -eq $adapter) { >> %temp%\dns-config-temp.ps1
echo     Write-Host 'ERROR: No active network adapter found!' -ForegroundColor Red >> %temp%\dns-config-temp.ps1
echo     pause >> %temp%\dns-config-temp.ps1
echo     exit >> %temp%\dns-config-temp.ps1
echo } >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host "Using adapter: $($adapter.Name)" -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host 'Setting DNS server...' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo try { >> %temp%\dns-config-temp.ps1
echo     Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses $dnsServer >> %temp%\dns-config-temp.ps1
echo     Write-Host "DNS server set to: $dnsServer" -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo } catch { >> %temp%\dns-config-temp.ps1
echo     Write-Host "Error setting DNS: $($_.Exception.Message)" -ForegroundColor Red >> %temp%\dns-config-temp.ps1
echo     pause >> %temp%\dns-config-temp.ps1
echo     exit >> %temp%\dns-config-temp.ps1
echo } >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host 'Setting DNS suffix...' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo try { >> %temp%\dns-config-temp.ps1
echo     Set-DnsClient -InterfaceIndex $adapter.ifIndex -ConnectionSpecificSuffix $dnsSuffix >> %temp%\dns-config-temp.ps1
echo     Write-Host "DNS suffix set to: $dnsSuffix" -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo } catch { >> %temp%\dns-config-temp.ps1
echo     Write-Host "Warning: Could not set DNS suffix: $($_.Exception.Message)" -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1
echo } >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host 'Testing DNS connectivity...' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo $pingResult = Test-Connection -ComputerName $dnsServer -Count 2 -Quiet >> %temp%\dns-config-temp.ps1
echo if ($pingResult) { >> %temp%\dns-config-temp.ps1
echo     Write-Host "DNS server $dnsServer is reachable!" -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo } else { >> %temp%\dns-config-temp.ps1
echo     Write-Host "WARNING: Cannot ping DNS server $dnsServer" -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1
echo     Write-Host 'Check network cable and switch configuration' -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1
echo } >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host 'Testing domain resolution...' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo $dnsTest = Resolve-DnsName -Name $dnsSuffix -ErrorAction SilentlyContinue >> %temp%\dns-config-temp.ps1
echo if ($null -ne $dnsTest) { >> %temp%\dns-config-temp.ps1
echo     Write-Host "Domain $dnsSuffix is resolvable!" -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo } else { >> %temp%\dns-config-temp.ps1
echo     Write-Host "WARNING: Cannot resolve domain $dnsSuffix" -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1
echo     Write-Host 'The DNS server may not be configured correctly' -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1
echo } >> %temp%\dns-config-temp.ps1
echo. >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host '========================================' -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo Write-Host '   DNS Configuration Complete!' -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo Write-Host '========================================' -ForegroundColor Green >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host 'Current DNS Configuration:' -ForegroundColor Cyan >> %temp%\dns-config-temp.ps1
echo Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 ^| Format-Table -AutoSize >> %temp%\dns-config-temp.ps1
echo Write-Host '' >> %temp%\dns-config-temp.ps1
echo Write-Host 'You can now run the Domain-Join.bat script' -ForegroundColor Yellow >> %temp%\dns-config-temp.ps1

REM Run the PowerShell script
PowerShell -NoProfile -ExecutionPolicy Bypass -File %temp%\dns-config-temp.ps1

REM Clean up temporary file
del %temp%\dns-config-temp.ps1

echo.
pause
