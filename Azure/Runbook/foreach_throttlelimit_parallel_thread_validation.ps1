# This is sample Powershell Workflow Azure Runbook script used to evaluate foreach -parallel -throttlelimit behavior 
# Last used by Vijred on 4/9/2020

workflow TestWorkflow
{
    $workflowStartTime = [DateTime]::UtcNow
    $myarray = (1..510)
    try
	{
        write-output "Script here:"
        write-output "Array count: $($myarray.count)"

        $throttlelimit = [System.Math]::Round($($myarray.count)/4)
        write-output "Throttle Limit: $($throttlelimit)"

        foreach -parallel -ThrottleLimit $throttlelimit ($myvar in $myarray)
        {
            $waittime = get-random -minimum 2 -maximum 6
            write-output "$($myvar)-Starttime-$([DateTime]::UtcNow)-Wait time seconds : $($waittime)"
            Start-Sleep -s $waittime
            write-output "$($myvar)-endtime-$([DateTime]::UtcNow)"
        }

        $workflowFinished = [DateTime]::UtcNow    
        $workflowDuration = ($workflowFinished - $workflowStartTime)

        write-output "Main workflow completed. Duration $([System.Math]::Round($workflowDuration.TotalMinutes,3)) minutes"

    }
    catch {
        write-output "Error"
    }
}

