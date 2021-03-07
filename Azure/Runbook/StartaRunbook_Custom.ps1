
# This script is a custom scenario to start a runbook with different paramaters with X Seconds frequency, Stop and execute the Runboook again if the job is not completed within threshold

[CmdletBinding()]
param (
		[string]$InputFilePath
) #end param

$RunbookJobfrequencySeconds = 180  # Seconds 
$RunbookJobRestartMinutesThreshold = 85 # Minutes

Start-Transcript "Transcript_$(Get-Date -f MM-dd-yyyy_HHmmss).txt"

Write-Output "Input filename - $InputFilePath"
Get-Content $InputFilePath

# Test if you're logged in
$fgs = Import-Csv -Path $InputFilePath #03042021_FailoverGroups.csv
#$runbookName = "test-ps"
$runbookName = "myRunbookName"

if ($null -eq (Get-AzContext) ){
    Connect-AzAccount
}

Select-AzSubscription -SubscriptionName "MySubscriptioName"
$automationAccountName = "myAutomationAccount"
$ResourceGroupName = "myAutomationAccountResourceGroupName"
$RunbookJobRestartMinutesThreshold = $RunbookJobRestartMinutesThreshold * -1 

$AllJobs=@()

foreach($fg in $fgs){
	$FAILOVERGROUPNAME=$fg.fgname
	$Variable2=$fg.Variable2
	$params = @{"Variable2"=$Variable2;"FAILOVERGROUPNAME"=$FAILOVERGROUPNAME}

	$myjobinfo=Start-AzAutomationRunbook `
		-Name $runbookName `
		-Parameters $params `
		-AutomationAccountName $automationAccountName `
		-ResourceGroupName $ResourceGroupName ## -RunOn myHybridWorkerGroupName # RunOn is applicable only to execute the job in Hybrid worker 
        
    Write-Host "For FAILOVERGROUPNAME $($myjobinfo.JobParameters.$FAILOVERGROUPNAME), jobid- $($myjobinfo.JobId) - started at $($myjobinfo.CreationTime)"
	Start-Sleep -seconds $RunbookJobfrequencySeconds
    $AllJobs+=$myjobinfo

    foreach($Job in $AllJobs){
        if($Job.Status -notin ("Completed","Stopped","Suspended") ){
            $MyJobStatus=Get-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -JobId $Job.JobId
            ($AllJobs | Where-Object {$_.JobId -eq $MyJobStatus.JobId}).Status = $MyJobStatus.Status
            if ( ($MyJobStatus.LastStatusModifiedTime - (Get-Date)).minutes -le $RunbookJobRestartMinutesThreshold){
                Write-Host "Restarting-$($Job.JobId) - started at $($MyJobStatus.CreationTime) , has not update beyond threshold; restarting job for Poolname: $($MyJobStatus.JobParameters.FAILOVERGROUPNAME)"
                Stop-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -Id $($Job.JobId)

                $FAILOVERGROUPNAME=($fgs | Where-Object {$_.FAILOVERGROUPNAME -eq $MyJobStatus.JobParameters.FAILOVERGROUPNAME}).FAILOVERGROUPNAME
                $Variable2=($fgs | Where-Object {$_.FAILOVERGROUPNAME -eq $MyJobStatus.JobParameters.FAILOVERGROUPNAME}).Variable2
            	$params = @{"FAILOVERGROUPNAME"=$FAILOVERGROUPNAME;"Variable2"=$Variable2}

                $myjobinfo=Start-AzAutomationRunbook `
                -Name $runbookName `
                -Parameters $params `
                -AutomationAccountName $automationAccountName `
                -ResourceGroupName $ResourceGroupName `
                -RunOn PRHybridWorkers
                $AllJobs+=$myjobinfo
                Write-Host "RESTARTED JOB - For FAILOVERGROUPNAME $($MyJobStatus.JobParameters.FAILOVERGROUPNAME), jobid- $($myjobinfo.JobId) - started at $($myjobinfo.CreationTime)"
            }
        }
    }

    Get-Date -f MM-dd-yyyy_HH:mm:ss
    $AllJobs | Select-Object JobId, Status, LastModifiedTime | Format-Table
}

Write-Output "Final validation"
IF ($null -ne ($AllJobs | Where-Object {$_.Status -in ("Completed","Stopped","Suspended")}) )
{
    Start-Sleep -seconds $RunbookJobfrequencySeconds
    foreach($Job in $AllJobs){
        if($Job.Status -notin ("Completed","Stopped","Suspended") ){
            $MyJobStatus=Get-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -JobId $Job.JobId
            ($AllJobs | Where-Object {$_.JobId -eq $MyJobStatus.JobId}).Status = $MyJobStatus.Status
            if ( ($MyJobStatus.LastStatusModifiedTime - (Get-Date)).minutes -le $RunbookJobRestartMinutesThreshold){
                Write-Host "Restarting-$($Job.JobId) - started at $($MyJobStatus.CreationTime) , has not update beyond threshold; restarting job for Poolname: $($MyJobStatus.JobParameters.FAILOVERGROUPNAME)"
                Stop-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -Id $($Job.JobId)

                $FAILOVERGROUPNAME=($fgs | Where-Object {$_.FAILOVERGROUPNAME -eq $MyJobStatus.JobParameters.FAILOVERGROUPNAME}).FAILOVERGROUPNAME
                $Variable2=($fgs | Where-Object {$_.FAILOVERGROUPNAME -eq $MyJobStatus.JobParameters.FAILOVERGROUPNAME}).Variable2
            	$params = @{"FAILOVERGROUPNAME"=$FAILOVERGROUPNAME;"Variable2"=$Variable2}

                $myjobinfo=Start-AzAutomationRunbook `
                -Name $runbookName `
                -Parameters $params `
                -AutomationAccountName $automationAccountName `
                -ResourceGroupName $ResourceGroupName `
                -RunOn PRHybridWorkers
                $AllJobs+=$myjobinfo
                Write-Host "RESTARTED JOB - For FAILOVERGROUPNAME $($MyJobStatus.JobParameters.FAILOVERGROUPNAME), jobid- $($myjobinfo.JobId) - started at $($myjobinfo.CreationTime)"
            }
        }
    }
}

$AllJobs
Stop-Transcript
