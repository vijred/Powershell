
# Handy Powershell commands for Azure SQL Database Failover Groups 

# Create a new Failover Group 
$failoverGroup = New-AzureRMSqlDatabaseFailoverGroup -ResourceGroupName RGName -ServerName DBServerName -PartnerResourceGroupName DRRGName -PartnerServerName DRDBServerName -FailoverGroupName DBFailoverGroupName -FailoverPolicy Manual
 
# How to add all databases from a given elastic pool to Failover Group
$databases = Get-AzureRmSqlElasticPoolDatabase -ResourceGroupName RGName -ServerName DBServerName ElasticPoolName ElasticPoolName
$failoverGroup = $failoverGroup | Add-AzureRmSqlDatabaseToFailoverGroup -Database $databases
 
 
# How to manually Failover a database
Set-AzureRmSqlDatabaseSecondary -ResourceGroupName DRRGName -ServerName DRDBServerName -DatabaseName DBName -Failover -PartnerResourceGroupName RGName
 
# Force failover with data loss
Get-AzureRmSqlDatabaseFailoverGroup -ResourceGroupName DRRGName -ServerName DRServerName -FailoverGroupName DBFailoverGroupName | Switch-AzureRmSqlDatabaseFailoverGroup -AllowDataLoss
 
# AZ module command to failover 
Switch-AzSqlDatabaseFailoverGroup -ResourceGroupName DRRGName -ServerName DRServerName -FailoverGroupName DBFailoverGroupName -AllowDataLoss
  
#az module command to get FailoverGroup Name 
Get-AzSqlDatabaseFailoverGroup -ResourceGroupName RGName -ServerName DBServerName -FailoverGroupName DBFailoverGroupName
 
# Few more commands
# az module command to create new Availability Group
New-AzSqlDatabaseFailoverGroup
