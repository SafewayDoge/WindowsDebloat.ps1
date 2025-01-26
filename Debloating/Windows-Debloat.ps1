if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}
$debloatPath = ".\Debloat.txt"
if (!(Test-Path $debloatPath) -or (Get-Item $debloatPath).LastWriteTime -lt (Get-Date).AddDays(-7)) {
    Invoke-WebRequest "https://github.com/mrhaydendp/RemoveEdge/raw/main/Individual%20Scripts/Debloat.txt" -OutFile $debloatPath
}
$disable = Get-Content $debloatPath
$appxPackages = Get-AppxPackage | Select-Object -ExpandProperty Name

foreach ($package in $disable) {
    $packageName = $package.Split(" #")[0]
    if ($appxPackages -contains $packageName) {
        Write-Host "Removing: $packageName"
        Get-AppxPackage $packageName | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
}
