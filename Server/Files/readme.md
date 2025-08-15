Powersehell Files 
=================




* Sample - On a given folder, copy latest .dacpac to predefinedFile    
    ```
    $updatePath = "C:\SBM\production\Client\"
    $ToBeFilename = "ApacheSchema.dacpac"

    $LastDeployeddacpac = Get-ChildItem "$updatePath\*.dacpac" | Sort {$_.LastWriteTime} | select -last 1
    if($LastDeployeddacpac.Name -ne $ToBeFilename )
    {
        Copy-Item  $LastDeployeddacpac -Destination "$updatePath\$ToBeFilename" -Force
    }

    ```

    * How to search for a string in a given parent folder
  `Get-ChildItem -Recurse -File | Select-String -Pattern "filecontentpattern"`
