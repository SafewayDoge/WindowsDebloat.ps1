# Checks if the script is running as Administrator, if not, re-launch it with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Check if Debloat.txt needs to be updated (older than 7 days)
$debloatFile = ".\Debloat.txt"
if ((Get-Item $debloatFile).LastWriteTime -lt (Get-Date).AddDays(-7)){
    Write-Host "Debloat.txt is outdated. Updating..."
    Invoke-WebRequest "https://raw.githubusercontent.com/SafewayDoge/WindowsDebloat.ps1/refs/heads/main/Debloating/Debloat.txt" -OutFile $debloatFile
}

# Read the list of packages to disable/remove from Debloat.txt
$disable = Get-Content $debloatFile

# Get all installed AppX packages and save to a file
(Get-AppxPackage).Name | Out-File appxpackages.txt

# Process each app in the Debloat.txt list
foreach ($array in $disable) {
    # Get package name before any comments (splitting by " #")
    $appName = ($array -split " #")[0]
    
    # Check if the package is installed
    if (Select-String -Quiet $appName appxpackages.txt) {
        Write-Host "Attempting to remove: $appName"
        
        # Attempt to remove the package
        try {
            Get-AppxPackage $appName | Remove-AppxPackage -Verbose
        } catch {
            Write-Warning "Failed to remove $appName: $_"
        }
    } else {
        Write-Host "$appName not found. Skipping removal."
    }
}

Write-Host "Debloating process completed."
