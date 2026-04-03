<# --------------------------------------------------------------------------
            Uninstall Zabbix Agent Script

            Author: Daniel Burrowes
            Date: Jan 2026
            Version: 1.0

            This script will uninstall the Zabbix Agent from the local machine.
            A system reboot will be required to complete the uninstall.

 -------------------------------------------------------------------------- #>

$zbx = "C:\Program Files\Zabbix Agent\zabbix_agentd.exe" 

If (Test-Path $zbx) 
{ 
    Write-Host "Stopping Zabbix Service" 
    Start-Process $zbx -ArgumentList "--stop" -PassThru -Verbose -Wait -ErrorAction Continue 
    
    Write-Host "Uninstalling Zabbix" 
    Start-Process $zbx -ArgumentList "--uninstall" -PassThru -Verbose -Wait -ErrorAction Stop

    } Else { 

    Write-Error "Zabbix Not Found" 
    exit 1
} 