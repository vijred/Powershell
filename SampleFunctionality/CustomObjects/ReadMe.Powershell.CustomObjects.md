# Custom Objects 

## New-Object can be used to create a custom object, following is the sample 
```
$EnvironmentDetails = New-Object -TypeName PSObject;
```


### Usage sample: Use combination of Array and Custom Object for real world usage 
```
$ServerArray = @()

	$EnvironmentDetails = New-Object -TypeName PSObject;
	Add-Member -InputObject $EnvironmentDetails -MemberType NoteProperty -Name EnvironmentName -Value "Pre-Prod";
	Add-Member -InputObject $EnvironmentDetails -MemberType NoteProperty -Name SubscriptionName -Value "DummyServerName_Preprod";
	$ServerAray += $EnvironmentDetails

	$EnvironmentDetails = New-Object -TypeName PSObject;
	Add-Member -InputObject $EnvironmentDetails -MemberType NoteProperty -Name EnvironmentName -Value "Prod";
	Add-Member -InputObject $EnvironmentDetails -MemberType NoteProperty -Name SubscriptionName -Value "DummyServerName_prod";
	$ServerAray += $EnvironmentDetails

$ServerArray
```

Author: [Vijay Kundanagurthi](http://twitter.com/vijred)