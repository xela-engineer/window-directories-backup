#   Description:
# This script helps to do backup and versioning backups

param (
    [Parameter(Mandatory=$true)][string]$workingDirPath,
    [Parameter(Mandatory=$true)][string]$backupStoragePath,
    [Parameter(Mandatory=$true)][string]$copyLogFilePath,
    [Parameter(Mandatory=$true)][Int64]$encryptedSlackToken,
    [string]$retentionDays = "1"
 )


$slackToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($encryptedSlackToken)

write-output $workingDirPath
write-output $backupStoragePath
function Send-Slack-MSG {
  param($message)
  $url = 'https://slack.com/api/chat.postMessage'
  $final_message = '[Backup Job] '+$message
  $token = $slackToken 
  $channel = 'working-space'
  $body = @{color = "good"; token = $token; channel = $channel; text = $final_message; pretty = 1 }
  Invoke-WebRequest -Uri $url -Method POST -Body $body
}

# Test-Script "The Doctor" "4.5 billion"
# Test-Script -Name Mother -Age 29

Write-Output "Start Mirroring Working Directory"
# Confirm can we access to the source directory or not
Set-Location $workingDirPath

$errorFlag = $?
if ( !$errorFlag )
{
    Write-Output "There are some problems with the source directory."
    Send-Slack-MSG("There are some problems with the source directory.")
}
# TODO: confirm do we have the destination directory or not. If not, create one.

# TODO: confirm do we have the log directory. If do not exist, create one.

#Robocopy $workingDirPath $backupStoragePath /MIR /R:3 /W:60 /E /ZB /MT:16 /LOG+:$copyLogFilePath

# TODO: what is the exit code of the above command?
# TODO: If not good, sent alert.

$url = 'https://slack.com/api/chat.postMessage'
$message = 'Working Directory Backup Success'
$token = $slackToken 
$channel = 'working-space'
$body = @{token = $token; channel = $channel; text = $message; pretty = 1 }
Invoke-WebRequest -Uri $url -Method POST -Body $body

# TODO: maintain the achieve versioning