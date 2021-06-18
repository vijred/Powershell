Powershell - SQL info 
=====================

* Good book reference on learning a given topic
    - https://livebook.manning.com/book/windows-powershell-in-action-second-edition/table-of-contents/1

* How to you check status of SQL Service on a givne server 
    - This cmdlet helps to find all instances of SQL Server `get-service mss* `

* *How to update SQL Cluster configuration to register single IP for its listener.
```
# Verify ClusterName 
(Get-ClusterResource | where {$_.OwnerGroup -ne "Cluster Group" -and $_.ResourceType -eq "Network Name"}).name

# verify RegisterAllProvidersIP and HostRecordTTL settings (1,300 is a good combination) 
$Clustername = (Get-ClusterResource | where {$_.OwnerGroup -ne "Cluster Group" -and $_.ResourceType -eq "Network Name"}).name
Get-ClusterResource $Clustername | Get-ClusterParameter RegisterAllProvidersIP,HostRecordTTL

# Update Cluster configuration for RegisterAllProvidersIP and HostRecordTTL (0,60 is a good combination) 
Get-ClusterResource $Clustername | Set-ClusterParameter RegisterAllProvidersIP 0
Get-ClusterResource $Clustername | Set-ClusterParameter HostRecordTTL 60

# Verify changes 
Get-ClusterResource $Clustername | Get-ClusterParameter RegisterAllProvidersIP,HostRecordTTL

# Validate Listener, still registers multiple IPs 
nslookup MyLiustenerName

# Restart Cluster (Application will be impacted) - You can also failover 
Stop-ClusterResource $Clustername
Start-ClusterResource $Clustername

## Potential othe option but not tested! 
#Get-ClusterNode shpdbwn1h02 | Get-ClusterGroup | Where-Object {$_.State -eq "Online"} | Move-ClusterGroup

# Verify single IP is registered for the Listener 
nslookup MyLiustenerName

# How to manually force DNS to update 
# 2012 and newer
Get-ClusterResource $Clustername | Update-ClusterNetworkNameResource
```

