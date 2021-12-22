
#ActiveDirectoryModuleInformation.ps1
## Created by Vijred on 3/24/2020

# Check if ActiveDirectory is installed
Get-Module ActiveDirectory

#Install AD Module
# --> Install  Remote Server Administration Tools

# import module
Import-Module ActiveDirectory


# Explore commandlets in ActiveDirectory 
get-command -module ActiveDirectory

# Most commonlyt used cmdlets 
Get-ADGroup
Get-ADGroupMember
Get-ADObject
Get-ADUser
Get-ADUser -Properties *

* How to get user from a different domain 
    - get-aduser UserAlias -Server domain.org.com 

    