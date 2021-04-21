# Sample Powershell to list all users logged of from given Server in last 3 days - User Name and Log-Off Date 

```
$r= Get-EventLog -Logname Security -InstanceId 4647  | Where-Object{$_.TimeGenerated -gt (Get-Date).AddDays(-3)} | Select-Object TimeGenerated, Message
$r  | ForEach-Object { if($_.Message -match 'Account Name:\s+(?<UserID>\S*)') { $Matches["UserID"], $_.TimeGenerated} } 
```


Author: [Vijay Kundanagurthi](http://twitter.com/vijred)
