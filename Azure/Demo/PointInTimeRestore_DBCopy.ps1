
<#
This simple demo was used during meetup presentation by Vijay Kundanagurthi on 12/2/2020 
# Created a SQL Server and a database for demo purpose before Demo! 

RG: EastUSRG122020
Server: vjdemoserver122020
Login: vjadmin
PW: 	
DB: vjdemodb
Pool: Pool1 


Create  Table for time trackign 

create table timetracker(id int identity(1,1), name nvarchar(100), insertdatetime datetime default(getdate()))
insert into timetracker(name) values('vj')
GO
select * from timetracker
#>



$subscriptionId = "eg3b1c52-db3f-4bbb-b51d-59df3ba619aex" # Dummy Subscription, replace! 

$resourceGroupName = "EastUSRG122020"
$serverName = "vjdemoserver122020"
$databaseName = "vjdemodb"
$pointInTime = "2020-12-02T18:57:00Z" 
$pointInTimeRestoreDatabaseName = "vjdemodb12021857"
$poolname = "Pool1"

Login-AzAccount
Select-AzSubscription -SubscriptionId $subscriptionId

$database = get-AzSqlDatabase -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName 

# Restore point in time DB to standalone DB 
Restore-AzSqlDatabase `
      -FromPointInTimeBackup `
		-PointInTime $pointInTime `
      -ResourceGroupName $resourceGroupName `
      -ServerName $serverName `
      -TargetDatabaseName $pointInTimeRestoreDatabaseName `
      -ResourceId $database.ResourceID `
      -Edition "Standard" `
      -ServiceObjectiveName "S0"

# Restore database to existing elastic pool	  
Restore-AzSqlDatabase `
      -FromPointInTimeBackup `
		-PointInTime $pointInTime `
      -ResourceGroupName $resourceGroupName `
      -ServerName $serverName `
      -TargetDatabaseName $pointInTimeRestoreDatabaseName `
      -ResourceId $database.ResourceID `
      -ElasticPoolName $poolname

# One more point in time restore 
$pointInTime = "2020-12-02T19:30:00Z" 
$pointInTimeRestoreDatabaseName = "vjdemodbPIT12021930"

Restore-AzSqlDatabase `
      -FromPointInTimeBackup `
	  -PointInTime $pointInTime `
      -ResourceGroupName $resourceGroupName `
      -ServerName $serverName `
      -TargetDatabaseName $pointInTimeRestoreDatabaseName `
      -ResourceId $database.ResourceID `
      -ElasticPoolName $poolname

# Copy a database (Restoer latest point in time DB 

$databaseNameCopy = "vjdemodbCopyDB2"
New-AzSqlDatabaseCopy -ResourceGroupName $resourceGroupName `
 -ServerName $serverName `
 -DatabaseName $databaseName `
 -CopyDatabaseName $databaseNameCopy `
 -ElasticPoolName $poolname 



## Delete the database 

# Restore point in time from a deleted database 
$pointInTimeUTC = "2020-12-02T19:30:00Z" 
$pointInTimeRestoreFromDeletedDatabaseName = "vjdemodbPIT12021930FromDeleted"

$DeletedDatabase = Get-AzSqlDeletedDatabaseBackup -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName
Restore-AzSqlDatabase -FromDeletedDatabaseBackup -DeletionDate $DeletedDatabase.DeletionDate `
-ResourceGroupName $DeletedDatabase.ResourceGroupName `
-ServerName $DeletedDatabase.ServerName `
-TargetDatabaseName $pointInTimeRestoreFromDeletedDatabaseName `
-ResourceId $DeletedDatabase.ResourceID `
-Edition "Standard" `
-ServiceObjectiveName "S2" `
-PointInTime $pointInTimeUTC


# Find list of all databases in given server 
$databases = Get-AzSqlDatabase -ServerName $serverName -ResourceGroupName $resourceGroupName
$databases | select DatabaseName, ElasticPoolName, ServerName

# List all elastic pools on given server 
$pools = Get-AzSqlElasticPool -ServerName $serverName -ResourceGroupName $resourceGroupName
$pools | select ElasticPoolName, ServerName ,Dtu ,DatabaseDtuMin ,DatabaseDtuMax
