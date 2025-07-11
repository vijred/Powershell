# Event Viewer on Windows Server - Powershell usage 


## Basic cmdlet to get Events 
`Get-EventLog`

## List all available EventLogs
`Get-EventLog -List`

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

## Complex filter against eventlog content 
```
$r =  Get-WinEvent -LogName 'Connectors - Integration Runtime' | Select-Object -First 1000000000 | Where-Object {$_.Message -like '*fab792f9-5980-4997-879b-bd1621cdfd54*'}
$r.count
```

## Command to find login and logout events - 
```
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4801} | Sort-Object TimeCreated -Descending | Select-Object -First 5
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4800} | Sort-Object TimeCreated -Descending | Select-Object -First 5
```



Author: [Vijay Kundanagurthi](http://twitter.com/vijred)
