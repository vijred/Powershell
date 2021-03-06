
# Sampel to start a Runbook using AZ cmdlets 

Login-AzAccount
Select-AzureRmSubscription -SubscriptionName "SubscriptionName"

$runbookName = "MyRunbookName"
$automationAccountName = "MYAutomationAccountName"
$ResourceGroupName = "MyResourceGroupName"

$ENVIRONMENTNAME="Param1"
$SERVERNAME="MYServerName"
$HybridWorkerGroupName = "HybridWorkerGroupName"
$Param3="Paarm3Value"
$Param4="Paarm4"

$params = @{"ENVIRONMENTNAME"=$ENVIRONMENTNAME;"SERVERNAME"=$SERVERNAME;"Param3"=$Param3;"POOLNAME"=$Param4}

Start-AzAutomationRunbook `
	-Name $runbookName `
	-Parameters $params `
	-AutomationAccountName $automationAccountName `
	-ResourceGroupName $ResourceGroupName
	-RunOn $HybridWorkerGroupName 

#Note -RunOn option to be removed if you are not using the Hybrid WorkerGroup
