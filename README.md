# Window Directories Backup Script

This repo aims for mirroring the working directory to backup USB device.

## Terminology

Robocopy = rsyn in Window

- /e	Copies subdirectories. This option automatically includes empty directories.
- /zb	Copies files in restartable mode. If file access is denied, switches to backup mode.
- /R:3 /W:60  2 retries and waiting 60 seconds between each retry
- /MT:16 16 multi-threaded copy operation

``` powershell
Robocopy $workingDirPath $backupStoragePath /MIR /R:3 /W:60 /E /ZB /MT:16 /LOG+:$copyLogFilePath
```

## Quick Start

Please change the .

``` powershell

# Then, Open VScode and start run/debug
```


## Development

Installation

- Install jdk 21
- Install marven

  ``` sh
  yum module enable maven:3.8
  yum install maven
  mvn --version
  ```

- Create Java project
  - Ref: [Java tutorial](https://code.visualstudio.com/docs/java/java-tutorial)



## Troubleshooting

#### Error ...

  ``` log

  ```

  Resolution:

# Ref:

1. [Slack & PowerShell](https://powershellisfun.com/2022/05/04/create-slack-messages-using-powershell/)

