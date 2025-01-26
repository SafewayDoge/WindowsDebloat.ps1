# Run with admin privileges if not already
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Update Debloat.txt if older than 7 days
if ((Get-Item .\Debloat.txt -ErrorAction SilentlyContinue).LastWriteTime -lt (Get-Date).AddDays(-7)) { Invoke-WebRequest "https://github.com/mrhaydendp/RemoveEdge/raw/main/Individual%20Scripts/Debloat.txt" -OutFile Debloat.txt }

# Remove matching packages
Get-Content Debloat.txt | ForEach-Object { 
    $pkg = $_.Split(" #")[0]
    Get-AppxPackage $pkg | Remove-AppxPackage -ErrorAction SilentlyContinue
}
