# Define the URL for Mozilla Firefox installer
$firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-stable&os=win&lang=en-US"
$installerPath = "$env:USERPROFILE\Downloads\firefox_installer.exe"

# Download Mozilla Firefox installer
Write-Host "Downloading Mozilla Firefox installer..."
Invoke-WebRequest -Uri $firefoxInstallerUrl -OutFile $installerPath

# Run the installer
Write-Host "Installing Mozilla Firefox..."
Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait

# Clean up the installer after installation
Remove-Item $installerPath

Write-Host "Mozilla Firefox installation complete."

# List of apps to remove
$appsToRemove = @(
    "Microsoft.YourPhone", "Microsoft.IeCompatApp", "Microsoft.WordPad", "Microsoft.BingWeather",
    "Microsoft.WindowsSoundRecorder", "Microsoft.MathematicalInputPanel", "Microsoft.GetStarted", 
    "Microsoft.StickyNotes", "Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.Photos", 
    "Microsoft.People", "Microsoft.MSPaint", "Microsoft.Office.OneNote", "Microsoft.OneDrive", 
    "Microsoft.Office.Desktop", "Microsoft.ZuneVideo", "Microsoft.MixedReality.Portal", 
    "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsMaps", "microsoft.windowscommunicationsapps", 
    "Microsoft.GrooveMusic", "Microsoft.GetHelp", "Microsoft.FeedbackHub", "Microsoft.Cortana", 
    "Microsoft.Camera", "Microsoft.WindowsAlarms", "Microsoft.3DViewer", "LinkedIn.LinkedIn", 
    "Microsoft.Todo", "Microsoft.Clipchamp", "Microsoft.Edge"
)

# Loop through and remove each app
foreach ($app in $appsToRemove) {
    Write-Host "Removing $app..."
    Get-AppxPackage -Name $app | Remove-AppxPackage
}

Write-Host "Uninstallation complete."
