# Sysmon-Install

This repository contains a PowerShell script to install Sysmon (System Monitor) on a Windows machine. Sysmon is a Windows system service and device driver that, once installed on a system, remains resident across system reboots to monitor and log system activity to the Windows event log.

# What is Sysmon 
Sysmon (System Monitor) is a Windows system service and device driver that monitors and logs system activity to the Windows event log. It is developed by Microsoft and is commonly used for security monitoring and incident response.

# Prerequisites
-Ensure you have administrative privileges on the target machine.
-Make sure the Sysmon executable is accessible via the network share path specified in the script.

### Script Overview
The script performs the following tasks:
- Defines the network path to the Sysmon executable.
- Checks if Sysmon is already installed by querying the Windows Registry.
- Installs Sysmon if it is not already installed.
- Provides output messages to indicate the status of the installation process.

### Usage
- Clone this repository to your local machine.
- Open PowerShell with administrative privileges.
- Navigate to the directory containing the script.
- Run the script using the following command:

    .\install-sysmon.ps1

# Script Details
### Define the Network Path
The script defines the network path to the Sysmon executable:

    $SysmonSharePath = "\\tech.local\SYSVOL\tech.local\scripts\Sysmon64.exe"

### Check Sysmon Installation
The Check-SysmonInstallation function checks if Sysmon is already installed by querying the Windows Registry:

    function Check-SysmonInstallation {
        param (
            [string]$RegistryKeyPath
        )
    
        $SysmonImagePath = (Get-ItemProperty -Path $RegistryKeyPath -Name ImagePath -ErrorAction SilentlyContinue).ImagePath
    
        if ($SysmonImagePath) {
            Write-Output "Sysmon64 est déjà installé sur cette machine"
            return $true
        } else {
            return $false
        }
    }

### Install Sysmon
The Install-Sysmon function installs Sysmon using the specified executable path:

    function Install-Sysmon {
        param (
            [string]$SysmonExecutablePath
        )
    
        Write-Output "Sysmon64 va être installé sur cette machine"
        & $SysmonExecutablePath -i -accepteula
    }

### Verify Executable Path and Install Sysmon
The script verifies the path to the Sysmon executable and installs Sysmon if it is not already installed:


    if (Test-Path -Path $SysmonSharePath -PathType Leaf) {
        $SysmonRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64"
    
        if (-not (Check-SysmonInstallation -RegistryKeyPath $SysmonRegistryKeyPath)) {
            Install-Sysmon -SysmonExecutablePath $SysmonSharePath
        }
    } else {
        Write-Output "Le chemin vers l'exécutable de Sysmon est incorrect ou inaccessible."
    }


# Contributing
Contributions are welcome! Please open an issue or submit a pull request if you have any suggestions or improvements.

