#   Description:
# This script helps to do backup and versioning backups

param (
    [Parameter(Mandatory=$true)][string]$workingDirPath,
    [Parameter(Mandatory=$true)][string]$backupStoragePath,
    [Parameter(Mandatory=$true)][string]$copyLogFilePath,
    [Parameter(Mandatory=$true)][string]$encryptedSlackToken,
    [string]$retentionDays = "1"
 )

function Send-Slack-MSG {
  param($message)
  $url = 'https://slack.com/api/chat.postMessage'
  $title = '[Backup Job]'
  #$final_message = '[Backup Job] '+$message
  $token = $slackToken 
  $channel = 'working-space'
  $body = @{ channel = $channel; attachments= @(    
    @{                    
        fallback =  "A plaintext message" #$Fallback
        color = "danger" #$Color
        pretext = "Attention" #$title #$Pretext
        #author_name = "Alex" #$AuthorName
        #author_link = 'http://ramblingcookiemonster.github.io/images/tools/wrench.png' #$AuthorLink
        #author_icon = 'http://ramblingcookiemonster.github.io/images/tools/wrench.png' #$AuthorIcon
        title = $title
        title_link = 'https://www.youtube.com/' #$TitleLink
        text = $message
        #fields = $Fields #Fields are defined by the user as an Array of HashTables.
        #image_url = $ImageURL
        #thumb_url = $ThumbURL
       
    }) }

  $json = $body | ConvertTo-Json -Depth 4
  $json = [regex]::replace($json,'\\u[a-fA-F0-9]{4}',{[char]::ConvertFromUtf32(($args[0].Value -replace '\\u','0x'))})
  $json = $json -replace "\\\\", "\"
  $headers = @{Authorization = "Bearer $token"}
  Invoke-WebRequest -Uri $url -Method POST -Body $json -ContentType 'application/json; charset=utf-8' -Headers $headers
}

write-output $encryptedSlackToken
[string]$slackToken = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encryptedSlackToken))
$slackToken = $slackToken -replace "\n",""

write-output $workingDirPath
write-output $backupStoragePath


# Test-Script "The Doctor" "4.5 billion"
# Test-Script -Name Mother -Age 29

Write-Output "Start Mirroring Working Directory"
# Confirm can we access to the source directory
$errorFlag = Test-Path $workingDirPath
if ( !$errorFlag )
{
    Send-Slack-MSG("Fail to accessing the source directory.")
    exit 1
}
# Confirm do we can access to destination directory
$errorFlag = Test-Path $backupStoragePath
if ( !$errorFlag )
{
    Send-Slack-MSG("Fail to accessing the destination directory.")
    exit 1
}
# confirm do we have the log directory.
$errorFlag = Test-Path $copyLogFilePath
if ( !$errorFlag )
{
    Send-Slack-MSG("Fail to accessing the LogFile.")
    exit 1
}

#Robocopy $workingDirPath $backupStoragePath /MIR /R:3 /W:60 /E /ZB /MT:16 /LOG+:$copyLogFilePath

# TODO: what is the exit code of the above command?
if ( $LASTEXITCODE -ne 0) {
    Throw "Something bad happened while executing $command. Details: $($result | Out-String)"
}
# TODO: If not good, sent alert.

$url = 'https://slack.com/api/chat.postMessage'
$message = 'Working Directory Backup Success'
$token = $slackToken 
$channel = 'working-space'
$body = @{token = $token; channel = $channel; text = $message; pretty = 1 }
Invoke-WebRequest -Uri $url -Method POST -Body $body

# TODO: maintain the achieve versioning