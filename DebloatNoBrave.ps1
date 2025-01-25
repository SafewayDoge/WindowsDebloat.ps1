# Run as Administrator
# Remove unwanted pre-installed apps

# List of apps to remove
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

# Removes apps
foreach ($app in $appsToRemove) {
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like "*$app*" | Remove-AppxProvisionedPackage -Online
}
end
