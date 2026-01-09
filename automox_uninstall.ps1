<# --------------------------------------------------------------------------
            Uninstall Automox Agent Script

            Author: Daniel Burrowes
            Date: Jan 2026
            Version: 1.0

            This script will uninstall the Automox Agent from the local machine.

 -------------------------------------------------------------------------- #>

$amagent = "Automox Agent" 
If (Get-Service -Name $amagent -ErrorAction SilentlyContinue) 
{
    Write-Host "Stopping AMAgent" 
    Stop-Service -Name $amagent -Force -ErrorAction Stop 
} Else { 
    Write-Host "Automox Agent Service Not Found" 
}   

If (Test-Path "C:\Program Files (x86)\Automox\amagent.exe") 
{
    Write-Host "Deregistering agent" 
    Start-Process "C:\Program Files (x86)\Automox\amagent.exe" -ArgumentList "--deregister" -PassThru -Wait -ErrorAction Stop

    Write-Host "Uninstalling Automox" 
    Start-Process MsiExec.exe -ArgumentList "/X{B69ED3AC-8608-40CE-A6DA-D10D801825BC} /qn /norestart" -PassThru -Wait -ErrorAction Stop
} Else { 
    Write-Host "Automox Agent Executable Not Found" 
}   

