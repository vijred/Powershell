Active Directory Powershell
------------
* one way to check password expiry - `net user AccountName /domain`

* Typically AD displays Datetime values like (Created, Last Login, etc) in a string format. Following method can be used to convert to readable format. (ReF: https://www.epochconverter.com/ldap)
```
$ADtimestampstring = "133485543052180025"
# Following result is a GMT Datetime value 
(Get-Date 1/1/1601).AddDays($ADtimestampstring/864000000000)
```
