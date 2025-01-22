# Définir le chemin réseau vers l'exécutable de SYSMON
$SysmonSharePath = "\\tech.local\SYSVOL\tech.local\scripts\Sysmon64.exe"

# Fonction pour vérifier si Sysmon est déjà installé
function Check-SysmonInstallation {
    param (
        [string]$RegistryKeyPath
    )

    # Chemin vers le fichier exécutable de Sysmon64 via lecture du Registre
    $SysmonImagePath = (Get-ItemProperty -Path $RegistryKeyPath -Name ImagePath -ErrorAction SilentlyContinue).ImagePath

    # Vérifier si Sysmon est installé
    if ($SysmonImagePath) {
        Write-Output "Sysmon64 est déjà installé sur cette machine"
        return $true
    } else {
        return $false
    }
}

# Fonction pour installer Sysmon
function Install-Sysmon {
    param (
        [string]$SysmonExecutablePath
    )

    Write-Output "Sysmon64 va être installé sur cette machine"
    & $SysmonExecutablePath -i -accepteula
}

# Vérifier que le chemin vers l'exécutable est correct
if (Test-Path -Path $SysmonSharePath -PathType Leaf) {
    # Chemin vers la clé de Registre de Sysmon (version 64 bits)
    $SysmonRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Sysmon64"

    # Vérifier si Sysmon est déjà installé
    if (-not (Check-SysmonInstallation -RegistryKeyPath $SysmonRegistryKeyPath)) {
        # Installer Sysmon si ce n'est pas déjà fait
        Install-Sysmon -SysmonExecutablePath $SysmonSharePath
    }
} else {
    Write-Output "Le chemin vers l'exécutable de Sysmon est incorrect ou inaccessible."
}
