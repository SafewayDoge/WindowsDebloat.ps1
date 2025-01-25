# List of app names (process names may vary)
$appsToStop = @(
    "YourPhone", "IeCompatApp", "WordPad", "BingWeather",
    "WindowsSoundRecorder", "MathematicalInputPanel", "GetStarted", 
    "StickyNotes", "ScreenSketch", "SkypeApp", "Photos", 
    "People", "MSPaint", "OneNote", "OneDrive", 
    "Office", "ZuneVideo", "MixedReality.Portal", 
    "MicrosoftSolitaireCollection", "WindowsMaps", "windowscommunicationsapps", 
    "GrooveMusic", "GetHelp", "FeedbackHub", "Cortana", 
    "Camera", "WindowsAlarms", "3DViewer", "LinkedIn", 
    "Todo", "Clipchamp", "Edge"
)

# Function to stop processes related to the app
function Stop-AppProcesses {
    param (
        [string]$appName
    )
    
    # Get all running processes that match the app name
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

# Function to remove the app for the current user
function Remove-App {
    param (
        [string]$appName
    )

    Write-Host "Attempting to remove $appName..."

    # Try to remove the app for the current user
    Get-AppxPackage -Name $appName | Remove-AppxPackage -ErrorAction SilentlyContinue

    # Check if app was removed
    $appRemoved = -not (Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue)

    if ($appRemoved) {
        Write-Host "$appName successfully removed."
    } else {
        Write-Host "Failed to remove $appName."
    }
}

# Loop through each app, stop its processes, and remove the app for the current user
foreach ($app in $appsToStop) {
    Stop-AppProcesses -appName $app
    Remove-App -appName $app
}

# Loop through each app and remove the app for all users
foreach ($app in $appsToStop) {
    Stop-AppProcesses -appName $app
    Remove-App -appName $app
}

Write-Host "All specified apps have been stopped and removed."
