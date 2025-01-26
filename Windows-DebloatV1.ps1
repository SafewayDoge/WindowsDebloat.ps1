# List of app names (process names may vary)
$appsToStop = @(
    "Microsoft.YourPhone", "Microsoft.IeCompatApp", "Microsoft.WordPad", "Microsoft.BingWeather",
    "Microsoft.WindowsSoundRecorder", "Microsoft.MathematicalInputPanel", "Microsoft.GetStarted", 
    "Microsoft.StickyNotes", "Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.Photos", 
    "Microsoft.People", "Microsoft.MSPaint", "Microsoft.Office.OneNote", "Microsoft.OneDrive", 
    "Microsoft.Office.Desktop", "Microsoft.ZuneVideo", "Microsoft.MixedReality.Portal", 
    "Microsoft.MicrosoftSolitaireCollection", "Microsoft.WindowsMaps", "microsoft.windowscommunicationsapps", 
    "Microsoft.GrooveMusic", "Microsoft.GetHelp", "Microsoft.FeedbackHub", "Microsoft.Cortana", 
    "Microsoft.Camera", "Microsoft.WindowsAlarms", "Microsoft.3DViewer", "LinkedIn.LinkedIn", 
    "Microsoft.Todo", "Microsoft.Clipchamp", "Microsoft.Edge", 
    "Microsoft.EdgeCore", "InternetExplorer", "WordPad"
)

# Function to stop processes related to the app 
function Stop-AppProcesses {
    param (
        [string]$appName
    )
    
    $processes = Get-Process | Where-Object { $_.Name -like "*$appName*" }
    
    if ($processes) {
        foreach ($process in $processes) {
            Write-Host "Stopping process: $($process.Name)"
            Stop-Process -Name $process.Name -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Host "No running processes found for $appName."
    }
}

# Function to remove the app
function Remove-App {
    param (
        [string]$appName
    )

    Write-Host "Attempting to remove $appName..."

    Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction SilentlyContinue

    $appRemoved = -not (Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue)

    if ($appRemoved) {
        Write-Host "$appName successfully removed."
    } else {
        Write-Host "Failed to remove $appName."
    }
}

# Loop through each app, stop its processes, and remove the app
foreach ($app in $appsToStop) {
    Stop-AppProcesses -appName $app
    Remove-App -appName $app
}

Write-Host "All specified apps have been stopped and removed."
