# Check if the script is running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    Exit
}

    $bloatApps = @(
        "Microsoft.YourPhone", "Microsoft.IeCompatApp", "Microsoft.WordPad", "Microsoft.BingWeather",
        "Microsoft.WindowsSoundRecorder", "Microsoft.MathematicalInputPanel", "Microsoft.GetStarted", 
        "Microsoft.StickyNotes", "Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.Photos", 
        "Microsoft.People", "Microsoft.MSPaint", "Microsoft.Office.OneNote", "Microsoft.OneDrive", 
        "Microsoft.Office.Desktop", "Microsoft.ZuneVideo", "Microsoft.MixedReality.Portal", 
        "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsMaps", "microsoft.windowscommunicationsapps", 
        "Microsoft.GrooveMusic", "Microsoft.GetHelp", "Microsoft.FeedbackHub", "Microsoft.Cortana", 
        "Microsoft.Camera", "Microsoft.WindowsAlarms", "Microsoft.3DViewer", "LinkedIn.LinkedIn", 
        "Microsoft.Todo", "Microsoft.Clipchamp", "Microsoft.Edge"  # Added Microsoft Edge for removal
    )

    foreach ($app in $bloatApps) {
        # Stop any running processes related to the app before removal
        Stop-AppProcess -appName $app

        # Remove the app
        Write-Host "Removing $app..." -ForegroundColor Cyan
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
}

# Function to install Brave browser using Winget
function Install-Brave {
    Write-Host "Installing Brave Browser..." -ForegroundColor Yellow
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id=Brave.Brave -e --accept-source-agreements --accept-package-agreements
        Write-Host "Brave installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Winget is not installed. Please install Winget first." -ForegroundColor Red
    }
}

Remove-Bloatware
Install-Brave
Restart-Computer -Force
