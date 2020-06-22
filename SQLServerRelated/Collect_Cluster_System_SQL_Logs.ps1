# Last updated on 2/18/2020 by Vijay 
# This script is to collect best available information from the server to debug an issue
# Collects following from all Servers in cluster
##  Cluster Logs
## Cluster Diagnostic Logs
## Application / System/ Security Logs
## SQL Logs which are last updated in last 3 days
## Cluster Diagnostic Logs
## Run this script from the location where the logs needs to be stored 

Import-Module FailoverClusters 

Get-ClusterLog -Destination .


$ClusterNodes = Get-ClusterNode | Where-Object {$_.State -eq "Up"} | select Name

foreach($ClusterNode in $ClusterNodes )
{

$Logfiles = Get-WmiObject -Class Win32_NTEventLogFile -ComputerName $ClusterNode.Name | Where-Object {$_.FileName -in "System","Application", "Security"} 

    foreach ($Logfile in $Logfiles)
    {
        $Filename = "\\$($Logfile.__SERVER)\$(($Logfile.Drive).Replace(':','$'))$($Logfile.Path)$($Logfile.LogfileName).$($Logfile.Extension)"
        Copy-Item $Filename -Destination ".\$($Logfile.__SERVER)_$($Logfile.LogfileName)_$(Get-Date -Format "yyyy-MM-dd-hh-mm").$($Logfile.Extension)"
    }

}

# Collecting SQL Logs that were modified in last 3 days
try
{
    $CopyPath = (Get-Location).Path
    $ClusterNodes = Get-ClusterNode | Where-Object {$_.State -eq "Up"} | select Name
    foreach($ClusterNode in $ClusterNodes )
    {
        $Inst = facter payx_sqlinstance
        if($null -ne $Inst -and $Inst -notlike "*MSSQLSERVER*")
        {
            $InstanceName = "$($ClusterNode.Name)\$(( ConvertFrom-Json $Inst ).instname)"
        }
        else{
            $InstanceName = $($ClusterNode.Name)
        }        

        $InstanceName
        $ErrorLogInfo = (Invoke-Sqlcmd -ServerInstance   $InstanceName -Database master -Query "xp_readerrorlog 0, 1, N'Logging SQL Server messages in file', NULL, NULL, NULL,'asc' ").Text
        $ErrorLogPath = ($ErrorLogInfo -replace "Logging SQL Server messages in file '" ,"") -replace "ERRORLOG'.", ""
        $ErrorLogFullPath = "\\$($ClusterNode.Name)\$($ErrorLogPath -replace ":", "$")"
        $DestinationPath = "$($CopyPath)\SQLLogs_$($ClusterNode.Name)"
        mkdir $DestinationPath
        Set-Location $CopyPath
        Get-ChildItem $ErrorLogFullPath |  Where-Object { $_.LastWriteTime -gt (get-date).AddDays(-3)}  | Copy-Item -Destination $DestinationPath

        $ClusterDiagFullPath = "\\$($ClusterNode.Name)\C$\windows\System32\Winevt\Logs\Microsoft-Windows-FailoverClustering*Diagnostic.evtx"
        Get-ChildItem $ClusterDiagFullPath | Copy-Item -Destination "$($CopyPath)\$($ClusterNode.Name)_ClusterDiag.evtx"
    
    }
}
catch
{
    "Error capturing SQL Server error Logs"   
}

#




