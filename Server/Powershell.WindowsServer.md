Powershell - Windows Server
===========================

* Sample Commands ot see list of available counts 
```
Get-Counter -Counter "\Processor(*)\% Processor Time"
Get-Counter -ListSet Memory
Get-Counter -ListSet *
$c=Get-Counter -ListSet *
$c | Where-Object {$_.CounterSetName -contains "sql" }
$sqlc = $c | Where-Object {$_.CounterSetName -like "*SQL*" } | select counter
```

* How to update environment vatiables (PATH)
```
# Update User environment variable
$env:Path += ";C:\terraform" 

# Update system environment variable
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\terraform",
    [EnvironmentVariableTarget]::Machine)

# Update System environment variable in different way using registry
    $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
    $newpath = "$($DownloadPath);$oldpath"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath        
    (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path        

```

* Find Network ports opened 
```
$allconnections=Get-NetTCPConnection | Select-Object -Property *
$allconnections | Select-Object -Property CreationTime, RemotePort, RemoteAddress | Sort-Object -Property CreationTime
```
