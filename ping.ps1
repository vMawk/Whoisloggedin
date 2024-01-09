Write-Host "github.com/vmawk"
$computer = Read-Host -Prompt "Enter the name of the computer you want to check"
$ping = Test-Connection -ComputerName $computer -Count 1 -ErrorAction SilentlyContinue
if ($ping) {
    $users = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computer).UserName
    if ($users) {
        $uptime = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).LastBootUpTime
        $uptime = [Management.ManagementDateTimeConverter]::ToDateTime($uptime)
        $uptime = (Get-Date) - $uptime
        Write-Host "                                                  "
        Write-Host "The following users are logged in to $($computer):"
        Write-Host $users -ForegroundColor yellow
        Write-Host "The uptime of $($computer) is $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes, and $($uptime.Seconds) seconds." -ForegroundColor black -BackgroundColor white
        Write-Host "                                                  "
        Write-Host "                                                  "
        Write-Host "What would you like to do?"
        Write-Host "1. Shutdown"
        Write-Host "2. Restart"
        Write-Host "3. Sign out user (Not Ready)"
        Write-Host "4. Exit"
        $choice = Read-Host -Prompt "Enter your choice (1, 2, 3, or 4)"
        switch ($choice) {
            1 {
                Stop-Computer -ComputerName $computer -Force
            }
            2 {
                Restart-Computer -ComputerName $computer -Force
            }
            3 {
                $session = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computer).SessionId
                $result = (Invoke-CimMethod -ClassName Win32_OperatingSystem -ComputerName $computer -MethodName Win32Shutdown -Arguments @{Flags = 0;Reserved = 0;ReasonCode = 0;Comment = "";Timeout = 0;Force = $true}).ReturnValue
                if ($result -eq 0) {
                    Write-Host "User has been signed out successfully."
                } else {
                    Write-Host "Failed to sign out user."
                }
            }
            4 {
                Write-Host "Exiting the script..."
                Exit
            }
            default {
                Write-Host "Invalid choice. Please enter 1, 2, 3, or 4."
            }
        }
    } else {
        Write-Host "No one is logged in to $($computer)."
    }
} else {
    Write-Host "$($computer) is not online."
}
Start-Sleep -Seconds 5
