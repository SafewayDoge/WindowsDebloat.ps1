# Define the URL for Mozilla Firefox installer
$firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-stable&os=win&lang=en-US"
$installerPath = "$env:USERPROFILE\Downloads\firefox_installer.exe"

# Download Mozilla Firefox installer
Write-Host "Downloading Mozilla Firefox installer..."
Invoke-WebRequest -Uri $firefoxInstallerUrl -OutFile $installerPath

# Run the installer
Write-Host "Installing Mozilla Firefox..."
Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait

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

# Function to remove an app with retries
function Remove-AppWithRetry {
    param (
        [string]$appName
    )
    
    $maxRetries = 5
    $retryCount = 0
    $appRemoved = $false
    
    while ($retryCount -lt $maxRetries -and -not $appRemoved) {
        Write-Host "Attempting to remove $appName... (Attempt $($retryCount + 1))"
        
        # Try to remove the app for the current user
        Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2  # Wait a bit before checking again
        
        # Check if the app is still installed
        $appRemoved = -not (Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue)
        
        if ($appRemoved) {
            Write-Host "$appName successfully removed."
        } else {
            Write-Host "$appName still present, retrying..."
            $retryCount++
        }
    }

    if (-not $appRemoved) {
        Write-Host "$appName could not be removed after $maxRetries attempts."
    }
}

# Loop through and remove each app for the current user with retries
foreach ($app in $appsToRemove) {
    Remove-AppWithRetry -appName $app
}

Write-Host "Uninstallation complete."
