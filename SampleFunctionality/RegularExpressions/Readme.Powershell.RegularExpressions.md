# Regular Expressions in Powershell 


## -match is simple way in Powershell ot match a regex and find if the match exists or not 
``` Powershell
if("Domain\UserName" -match "(?<Domain>\w+)\\(?<UserName>\w+)"){
    $matches
} 
```


### Sample Powershell to list all users logged of from given Server in last 3 days - User Name and Log-Off Date 
``` Powershell 
$r= Get-EventLog -Logname Security -InstanceId 4647  | Where-Object{$_.TimeGenerated -gt (Get-Date).AddDays(-3)} | Select-Object TimeGenerated, Message
$r  | ForEach-Object { if($_.Message -match 'Account Name:\s+(?<UserID>\S*)') { $Matches["UserID"], $_.TimeGenerated} } 
```


## Example to replace 
```
$string = 'hello, world, What is next'
$string -replace '(.*), (.*)','$2,$1'
```



#### Quick Reference 
```
-match
$matchex
System.Text.RegularExpression.Regex
\ - Escape character
. - Single Char
[mn] - any 1 char out of m, n
[1-9] - Range from 1 through 9
^ - Negate [^A-E], Not A through E
^ starting of the line 
$ End line
\w - Character
\+ - any number of repeats 
\W - non word
\s - Space
\S - non-space
\d - Decimal
\D - non-decimal
{Ll} - ? 
{3} - Exactly 3 matches
{4,9} - 4 through 9 matches
\* - 0 or more repeats
? - 0 or 1 match
( ) - group regex
(?<name>) - Named 
| - or
"Domain\UserName" -match "(?<Domain>\w+)\\(?<UserName>\w+)"; $matches
(i) case insensitive
($-i) case sensitive 
(?m)
(?s)
-split
-replace
-match
```

* Good reference to 
    -   Doc: https://towardsdatascience.com/everything-you-need-to-know-about-regular-expressions-8f622fe10b03
    -   Play with Examples: https://regex101.com/

Author: [Vijay Kundanagurthi](http://twitter.com/vijred)
