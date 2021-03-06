Powershell Productivity tips usecases 
======================


* Copy history of cmdlets to Clipboard 
    - `Get-History -Count 46 | Set-Clipboard`
        - This is very helpful to document one time experiments
* Get list of commands 
    - `Get-Command -Module Az.Automation`
* How to assign a variable with multiple special characters
``` 
$var= @"
{"instname":"MySQLInstance","version":"12.0.6433.1","patchstatus":"current"}
"@
```
* Easiest way to keep track of Powershell console output, using transcript (Loggin)
    - Consider using [PowerShellLogging module](https://www.powershellgallery.com/packages/PowerShellLogging/1.3.0)
    - Alternative option is to use Transcript , sample listed below
```
Start-Transcript "Transcript_$(Get-Date -f MM-dd-yyyy_HHmmss).txt"
Stop-transcript 
```



Module related
--------------
* Importing a module 
    - `Import-Module Az.Automation`
* Install a module with given version
    - `Install-Module -Name AzureRM.Automation -MaximumVersion 6.1.1`
* How to find all repositories configured, that will be used during Intall-module
    - `Get-PSRepository`
* How to register default Repository
    - `Register-PSRepository -Default -Verbose`
        - Sampel output 
```  
VERBOSE: Performing the operation "Register Module Repository." on target "Module Repository 'PSGallery' () in provider
 'PowerShellGet'.".
VERBOSE: Repository details, Name = 'PSGallery', Location = 'https://www.powershellgallery.com/api/v2'; IsTrusted =
'False'; IsRegistered = 'True'.
```        
* Find a module in Repo
    - `Find-Module -Name AzureRM.Automation`
        - Workaround that helped with error - `WARNING: Unable to resolve package source 'https://www.powershellgallery.com/api/v2'`
            - `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` -> Ref: https://www.powershellcenter.com/2020/08/27/powershell-fix-warning-unable-to-resolve-package-source-https-www-powershellgallery-com-api-v2/
* Uninstall a module
    - `Get-Module AzureRM.profile -ListAvailable | Uninstall-Module`
* Trust Gallary
    - `Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted`
* How to use Scriptblock variable
```
$servers=("Server1","Server2")

$myScriptblock = @"
IF (`$null -ne (Get-Content C:\ProgramData\PuppetLabs\facter\facts.d\mypuppetfact.txt | Select-String -Pattern "(=Pattern1|=Pattern2)")){
c:\mydir\mycorrectionscript.ps1 -var1 value1 -var2 value2 -var3 value3
}else{
	write-output "mypuppetfact pattern is inaccurate, no action will be taken"
}
"@

$NewScriptBlock = [scriptblock]::Create($myScriptblock)

Invoke-Command -ComputerName dbadbwdvw1 -ScriptBlock $NewScriptBlock
foreach ($servername in $servers) {
	Invoke-Command -ComputerName $servername -ScriptBlock $NewScriptBlock
}
```
* Compare 2 arrays - Different ways
```
#1
$array | ForEach-Object {
    if ($array2 -contains $_) {
        Write-Host "`$array2 contains the `$array1 string [$_]"
    }
}

#2
$array | Where-Object -FilterScript { $_ -in $array2 }

#3
Compare-Object -ReferenceObject $array -DifferenceObject $array2


```