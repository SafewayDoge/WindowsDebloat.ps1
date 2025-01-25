# RUN AS ADMIN
# Remove unwanted pre-installed apps
# Installes Brave Browser

$appsToRemove = @(
    "Microsoft.3DBuilder",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.People",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MicrosoftToDo",
    "Microsoft.YourPhone",
    "Microsoft.WindowsMaps",
    "Microsoft.StickyNotes",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MSPaint",
    "Microsoft.WindowsCalculator",
    "Microsoft.OneNote",
    "Microsoft.Windows.Photos",
    "Microsoft.BingWeather",
    "Microsoft.MicrosoftNews",
    "Microsoft.Tips"
    "Microsoft.edge",
)

foreach ($app in $appsToRemove) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "*$app*" | Remove-AppxProvisionedPackage -Online
}

Invoke-Expression -Command "& { $(Invoke-RestMethod -Uri 'https://api.github.com/repos/brave/brave-browser/releases/latest').assets | Where-Object name -like '*setup.exe' | Select-Object -ExpandProperty browser_download_url }" | Start-Process -Wait

Write-Host "Selected apps have been removed. Brave has been installed." -ForegroundColor Green
