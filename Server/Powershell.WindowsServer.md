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

