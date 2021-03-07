
# How to get the job status 
Get-AzAutomationJob -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -JobId $JobId2



# See the outputs from a given JobID
Get-AzAutomationJobOutput -ResourceGroupName $ResourceGroupName -AutomationAccountName $automationAccountName -JobId $JobId2


# Note: How to get JobID
## JobId is one of the output parameters from `Start-AzAutomationRunbook` command 

