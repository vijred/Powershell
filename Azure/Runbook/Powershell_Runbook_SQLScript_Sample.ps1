

# Last used by Vijay on 4/24/2020

# Simple way to run a Powershell runbook and execute a SQL Query

#Get credentials using PSCredentials 
$SQLCredentials = Get-AutomationPSCredential -Name 'AzureDBAdmin'
$SqlUserName = $SQLCredentials.UserName
$SqlPwd = $SQLCredentials.GetNetworkCredential().Password

# Define database and Servername 
$DBName = "MyDatabase"
$ServerName = "MyAzureServer.database.windows.net"

$ConnectionString = "Server=$ServerName;Database=$DBName;User ID=$SqlUserName;Password=$SqlPwd;Encrypt=True;TrustServerCertificate=False;Connection Timeout=90;"
$conn = New-Object 'System.Data.SqlClient.SqlConnection'($ConnectionString)
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = "
 insert into test1 (insertdate, username ) values (getdate(), SYSTEM_USER)
"
$cmd.ExecuteNonQuery()
$conn.Close()
