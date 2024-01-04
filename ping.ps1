        Write-Host "------------------Talpa Network-------------------"
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
        Write-Host $users
        Write-Host "                                                  "
        Write-Host "                                                  "
        Write-Host "The uptime of $($computer) is $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes, and $($uptime.Seconds) seconds."
    } else {
        Write-Host "No one is logged in to $($computer)."
    }
} else {
    Write-Host "$($computer) is not online."
}
Start-Sleep -Seconds 5