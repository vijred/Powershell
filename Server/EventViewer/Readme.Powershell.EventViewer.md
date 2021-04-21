# Event Viewer on Windows Server - Powershell usage 


## Basic cmdlet to get Events 
Get-EventLog


## Get Events from given Source 
```
Get-EventLog -Logname Security
Get-EventLog -Logname Application
```

## Find registered event sources - This will be useful while writing events 
```
$LogName = 'System'
$path = "HKLM:\System\CurrentControlSet\services\eventlog\$LogName"
Get-ChildItem -Path $path -Name 
```



## Samples 
### Search Security Logs generated in last 3 days 
```
Get-EventLog -Logname Security | Where-Object{$_.TimeGenerated -gt (Get-Date).AddDays(-3)}
```


### Search Security Log with Given ID (4647 is LogOff event)
```
Get-EventLog -Logname Security -InstanceId 4647 
```


### Select last 2 Logoff activities in last 3 days , Display only Time and Message 
```
Get-EventLog -Logname Security -InstanceId 4647  | Where-Object{$_.TimeGenerated -gt (Get-DateAddDays(-3)} |Select-Object -First 2  | Select-Object TimeGenerated, Message
```




Author: [Vijay Kundanagurthi](http://twitter.com/vijred)
