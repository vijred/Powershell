
## Other option is: net user /domain UserAlias 

([string]$UserId)


$UserId = "vijayusername"
$groups = @()

Import-Module ActiveDirectory

$ui = Get-ADUser -Identity $UserId -Properties memberof 

ForEach($gdn in $($ui.MemberOf))
{
    $groups +=  Get-ADGroup -Identity $gdn -Properties Name, GroupScope, GroupCategory, SamAccountName, mail, proxyAddresses 
<#    $groups += Get-ADGroup -Identity $gdn -Properties proxyAddresses | Select-Object Name, GroupScope, GroupCategory, SamAccountName, mail, proxyAddresses
    (Get-ADGroup -Identity $gdn).proxyAddresses
    Get-ADGroup -Identity $gdn -Properties *
    #>
} 

$groups | Select-Object Name, GroupScope, GroupCategory, SamAccountName, mail | Sort-Object Name | Format-Table


# Get-ADGroup -Identity ($ui.MemberOf)[10] -Properties *
# Get-ADGroup -Identity ($ui.MemberOf)[1] -Properties * 
## SQL Way of doing it exec xp_logininfo 'Domain\vijay','all'; 

