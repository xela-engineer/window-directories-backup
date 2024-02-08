#   Description:
# This script helps to do backup and versioning backups

param (
    [Parameter(Mandatory=$true)][string]$workingDirPath,
    [Parameter(Mandatory=$true)][string]$backupStoragePath,
    [Parameter(Mandatory=$true)][string]$copyLogFilePath,
    [Parameter(Mandatory=$true)][string]$slackToken,
    [string]$retentionDays = "1"
 )

write-output $workingDirPath
write-output $backupStoragePath
# function Test-Script {
#   param($Name,$Age)
#   "$Name is roughly $Age years old"
# }

# Test-Script "The Doctor" "4.5 billion"
# Test-Script -Name Mother -Age 29

Write-Output "Start Mirroring Working Directory"

# /e	Copies subdirectories. This option automatically includes empty directories.

# /zb	Copies files in restartable mode. If file access is denied, switches to backup mode.
# /R:3 /W:60  2 retries and waiting 60 seconds between each retry
# /MT:16 16 multi-threaded copy operation
Robocopy $workingDirPath $backupStoragePath /MIR /R:3 /W:60 /E /ZB /MT:16 /LOG+:$copyLogFilePath


$url = 'https://slack.com/api/chat.postMessage'
$message = 'Working Directory Backup Success'
$token = $slackToken 
$channel = 'working-space'
$body = @{token = $token; channel = $channel; text = $message; pretty = 1 }
Invoke-WebRequest -Uri $url -Method POST -Body $body
