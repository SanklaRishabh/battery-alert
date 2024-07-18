# Add Windows Forms Assembly for creating GUI elements.
Add-Type -AssemblyName System.Windows.Forms


# Create a function for displaying notifications.
function Show-Notification {
    param (
        [string]$Message,
        [string]$Title
    )

    # Create a Windows Forms object.
    $global:Balloon = New-Object System.Windows.Forms.NotifyIcon
    $Balloon.Icon = [System.Drawing.SystemIcons]::Information
    $Balloon.BalloonTipText = $Message
    $Balloon.BalloonTipTitle = $Title
    $Balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
    $Balloon.Visible = $true

    $Balloon.ShowBalloonTip(10000)

    # Play the warning sound.
    Play-Sound -SoundFilePath $SoundFile

    # Hold the event for 10 seconds.
    Start-Sleep -Seconds 10

    $Balloon.Dispose()
}


# Create a function for playing warning sound.
function Play-Sound {
    param (
        [string]$SoundFilePath
    )

    # Create a new SoundPlayer object.
    $Player = New-Object System.Media.SoundPlayer
    $Player.SoundLocation = $SoundFilePath

    $Player.PlaySync()
}


# Set the path to the warning audio file.
$SoundFile = "<full-path-to-the-sound-file>"  # Add the full path to the sound file.

while ($true) {
    $BatteryStatus = Get-WmiObject -Class Win32_Battery

    foreach ($Battery in $BatteryStatus) {
        $BatteryPercent = $Battery.EstimatedChargeRemaining

        # Change the values to set a custom limit.
        if ($BatteryPercent -lt 20) {
            Show-Notification -Message "Battery is below 20%! Current level: $BatteryPercent%" -Title "Battery Alert"
        } elseif ($BatteryPercent -gt 80) {
            Show-Notification -Message "Battery is above 80%! Current level: $BatteryPercent%" -Title "Battery Alert"
        }
    }

    # Check after every five minutes.
    Start-Sleep -Seconds 300
}
