
# This is an easy way to query a single or multiple databases on a given elastic pool; 
#

# ExecuteSqlOnElasticPool -ServerInstanceNameFull "ServerShortName025.database.windows.net" -DBorElasticPoolName S025-P005 -resulttsql "select DB_NAME() AS DatabaseName, count(*) as tablecount from sys.tables " -dbcountlimit 5
#
# ExecuteSqlOnElasticPool -ServerInstanceNameFull "ServerShortname025.database.windows.net" -DBorElasticPoolName S025-P005 -resulttsql "select DB_NAME() AS DatabaseName, count(*) as tablecount from sys.tables " -dbcountlimit 5

function ExecuteSqlOnElasticPool
(
	[parameter(Mandatory=$false)] $ServerInstanceNameFull = "ServerShortname.database.windows.net",
	[parameter(Mandatory=$false)] $DBorElasticPoolName = "master",
	[parameter(Mandatory=$true)] $resulttsql,
	[parameter(Mandatory=$true)] $dbcountlimit = 0
)
{
	# $ServerInstanceNameFull = "stmdbprc025.database.windows.net"
	# $DBorElasticPoolName = "S025-P005"
	# $resulttsql	= "select DB_NAME() AS DatabaseName, count(*) as tablecount from sys.tables "

	$mysqlprofile = "C:\tmp\" + [Environment]::UserName + "_sqlProfile.json"
	[PSCredential] $SqlAuthCredential = Import-CliXml $mysqlprofile

	IF ($ServerInstanceNameFull -notmatch "database.windows.net" ) { $ServerInstanceNameFull = $ServerInstanceNameFull + ".database.windows.net"}

	$FindDBSQL = 
	"SELECT
		   @@SERVERNAME as [ServerName],
		   dso.elastic_pool_name,
		   d.name as DatabaseName
	FROM
		   sys.databases d inner join sys.database_service_objectives dso on d.database_id = dso.database_id
	WHERE d.Name  <> 'master'
	and dso.elastic_pool_name = '$($DBorElasticPoolName)'

	union 

	SELECT        @@SERVERNAME as [ServerName],
		   '' AS  elastic_pool_name,
		   d.name as DatabaseName
	FROM SYS.Databases d
	WHERE name = '$($DBorElasticPoolName)' "


	$AllDatabases = Invoke-Sqlcmd -ServerInstance $ServerInstanceNameFull -Database master -Username $SqlAuthCredential.UserName -Password $SqlAuthCredential.GetNetworkCredential().Password -Query $FindDBSQL


	$AllResults = @()

	if($AllDatabases -ne $null)
	{
#		write-host "Database(s) exists"
		foreach ($Database in  $AllDatabases | Select-Object -First $dbcountlimit)
		{
			$Obj = Invoke-Sqlcmd -ServerInstance $ServerInstanceNameFull -Database $($Database.DatabaseName) -Username $SqlAuthCredential.UserName -Password $SqlAuthCredential.GetNetworkCredential().Password -Query $resulttsql		
			$AllResults += $Obj			
		}
	}

	return $AllResults
}
