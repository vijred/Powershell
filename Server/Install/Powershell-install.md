
# Sample install from iso

Start-Process powershell -verb RunAs
...
Start-BitsTransfer -Source "http://repomanlocation.xyz.com/packages/filename_safdsf.iso" -Destination "C:\temp\fod.iso"
$m = Mount-DiskImage C:\temp\fod.iso
Get-WindowsCapability -Name RSAT* -Online  | Add-WindowsCapability -Online -LimitAccess -Source "$(($m | Get-Volume).DriveLetter):\"
Dismount-DiskImage C:\temp\fod.iso
Remove-Item C:\temp\fod.iso
