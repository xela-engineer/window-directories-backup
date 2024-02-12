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
# TODO: confirm can we access to the source directory or not

# TODO: confirm do we have the destination directory or not. If not, create one.

# TODO: confirm do we have the log directory. If do not exist, create one.

Robocopy $workingDirPath $backupStoragePath /MIR /R:3 /W:60 /E /ZB /MT:16 /LOG+:$copyLogFilePath

# TODO: what is the exit code of the above command?
# TODO: If not good, sent alert.

$url = 'https://slack.com/api/chat.postMessage'
$message = 'Working Directory Backup Success'
$token = $slackToken 
$channel = 'working-space'
$body = @{token = $token; channel = $channel; text = $message; pretty = 1 }
Invoke-WebRequest -Uri $url -Method POST -Body $body

# TODO: maintain the achieve versioning