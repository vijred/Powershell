
## Process to create Scoped credentials on Azure storage container and string to create Database Scoped Credentials 

$cred=Get-Credential
Connect-azaccount -Credential $cred

$SubscriptionId = "12345678-abcd-1234-1234-123456789123" # Replce SubscriptionId
Select-AzSubscription -SubscriptionId $SubscriptionId;


$policySasStartTime  = '2017-10-01';
$policySasExpiryTime = '2021-12-31T11:59:59Z';

$storageAccountLocation = 'eastus'; # Change Data Center 
$storageAccountName     = 'StorageAccountName'; # Change Storage acocunt Name 
$contextName            = 'YOUR_CONTEXT_NAME';  #leave this as is
$containerName          = 'ContainerName'; # Container Name, create Blob container 
$policySasToken         = ' ? ';
$policySasPermission = 'rwl';  # Leave this value alone, as 'rwl'.

$resourcegroupname = "StorageAcocuntResourceGorupName" # This is the resource group for Storage account 
$accessKey_ForStorageAccount = `
    (Get-AzStorageAccountKey `
        -Name              $storageAccountName `
        -ResourceGroupName $resourceGroupName
        ).Value[0];
#$accessKey_ForStorageAccount
$context = New-AzStorageContext `
    -StorageAccountName $storageAccountName `
    -StorageAccountKey  $accessKey_ForStorageAccount;
#$context
New-AzStorageContainerStoredAccessPolicy `
    -Container  $containerName `
    -Context    $context `
    -Policy     $policySasToken `
    -Permission $policySasPermission `
    -ExpiryTime $policySasExpiryTime `
    -StartTime  $policySasStartTime;
try {
    $sasTokenWithPolicy = New-AzStorageContainerSASToken `
        -Name    $containerName `
        -Context $context `
        -Policy  $policySasToken;
}
catch {
    $Error[0].Exception.ToString();
}
# $sasTokenWithPolicy
$string = "create master key
go

create
    DATABASE SCOPED
    CREDENTIAL [" + $context.BlobEndPoint + $containerName + "]
    WITH
        IDENTITY = 'SHARED ACCESS SIGNATURE',
        SECRET = '" + $sasTokenWithPolicy.Substring(1) + "'
GO
";

# this is the command that can be used to create Database Scopped credentials so XEvents can be captured and stored in Azure Storage account!
write-host $string; 
