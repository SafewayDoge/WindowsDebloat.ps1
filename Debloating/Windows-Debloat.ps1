# Checks if running as Admin, if not, will re-launch as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
$disable = @(
    "Microsoft.3DViewer", "Microsoft.Alarm", "Microsoft.BingWeather", "Microsoft.Camera",
    "Microsoft.Clipchamp", "Microsoft.Cortana", "Microsoft.FeedbackHub", "Microsoft.GetHelp",
    "Microsoft.GetStarted", "Microsoft.GrooveMusic", "Microsoft.IeCompatApp", 
    "Microsoft.MathematicalInputPanel", "Microsoft.MicrosoftSolitaireCollection", 
    "Microsoft.MixedReality.Portal", "Microsoft.MSPaint", "Microsoft.Office.Desktop", 
    "Microsoft.Office.OneNote", "Microsoft.OneDrive", "Microsoft.People", "Microsoft.Photos", 
    "Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.StickyNotes", "Microsoft.Todo", 
    "Microsoft.WindowsAlarms", "Microsoft.WindowsCommunicationsApps", "Microsoft.WindowsMaps", 
    "Microsoft.WindowsSoundRecorder", "Microsoft.WordPad", "Microsoft.YourPhone", "Microsoft.ZuneVideo", 
    "Microsoft365Calendar", "Microsoft365Copilot", "InternetExplorer", "LinkedIn"
)
$installedApps = Get-AppxPackage | Select-Object -ExpandProperty Name
$disable | ForEach-Object {
    if ($installedApps -contains $_) {
        Write-Host "Removing: $_"
        try { Get-AppxPackage $_ | Remove-AppxPackage -Verbose } 
        catch { Write-Warning "Failed to remove $_: $_" }
    } else { Write-Host "$_ not found. Skipping." }
}
Write-Host "Debloating completed."
