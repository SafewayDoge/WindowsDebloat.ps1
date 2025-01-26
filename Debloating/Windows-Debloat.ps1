# RUN AS ADMIN
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Invoke-WebRequest "https://raw.githubusercontent.com/SafewayDoge/WindowsDebloat.ps1/refs/heads/main/Debloat.txt" -OutFile Debloat.txt

Get-Content Debloat.txt | ForEach-Object { Get-AppxPackage $_.Split(" #")[0] | Remove-AppxPackage -ErrorAction SilentlyContinue }
