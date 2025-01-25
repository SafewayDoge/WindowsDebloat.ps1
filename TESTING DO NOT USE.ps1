# RUN AS ADMIN
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!" -ForegroundColor Red
    Exit
}

# Function to stop any running processes for the app
function Stop-AppProcess {
    param ([string]$appName)
    Get-Process -Name $appName -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}

# Function to remove pre-installed apps
function Remove-Bloatware {
    $bloatApps = @(
        "Microsoft.YourPhone", "Microsoft.IeCompatApp", "Microsoft.WordPad", "Microsoft.BingWeather",
        "Microsoft.WindowsSoundRecorder", "Microsoft.MathematicalInputPanel", "Microsoft.GetStarted", 
        "Microsoft.StickyNotes", "Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.Photos", 
        "Microsoft.People", "Microsoft.MSPaint", "Microsoft.Office.OneNote", "Microsoft.OneDrive", 
        "Microsoft.Office.Desktop", "Microsoft.ZuneVideo", "Microsoft.MixedReality.Portal", 
        "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsMaps", "microsoft.windowscommunicationsapps", 
        "Microsoft.GrooveMusic", "Microsoft.GetHelp", "Microsoft.FeedbackHub", "Microsoft.Cortana", 
        "Microsoft.Camera", "Microsoft.WindowsAlarms", "Microsoft.3DViewer", "LinkedIn.LinkedIn", 
        "Microsoft.Todo", "Microsoft.Clipchamp"
    )

    foreach ($app in $bloatApps) {
        Stop-AppProcess -appName $app
        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
}

Remove-Bloatware
Restart-Computer -Force
