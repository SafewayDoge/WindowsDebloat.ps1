# If not Admin, run with Admin privileges 
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
	Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}
    Invoke-WebRequest "https://github.com/SafewayDoge/WindowsDebloat.ps1/raw/main/Individual%20Scripts/Debloat.txt" -OutFile Debloat.txt
}
# Read Debloat.txt into $disable variable & grab current list of appxpackages
$disable = Get-Content Debloat.txt
(Get-AppxPackage).Name | Out-File appxpackages.txt
# If package from Debloat.txt matches one from appxpackages.txt, attempt to remove it
foreach ($array in $disable){
    if (Select-String -Quiet $array.split(" #")[0] appxpackages.txt){
        Write-Host "Attempting to Remove: $array"
        Get-AppxPackage $array.split(" #")[0] | Remove-AppxPackage -Verbose
    }
}
end
