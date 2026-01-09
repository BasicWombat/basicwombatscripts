<# --------------------------------------------------------------------------
            Uninstall BitDefender Endpoint Security Tools

            Author: Daniel Burrowes
            Date: Jan 2026
            Version: 1.0

            This script will uninstall BitDefender Endpoint Security Tools from the local machine.
            Official documentation for the uninstall tool can be found here:
            https://shorturl.at/HO6wT

 -------------------------------------------------------------------------- #>
$pwd = "your_plain_text_password"
Write-Host "Uninstalling BitDefender" 

Start-Process ./BEST_uninstallTool.exe -ArgumentList "/noWait /password=$pwd" -PassThru -NoNewWindow -Verbose -Wait -ErrorAction Stop 