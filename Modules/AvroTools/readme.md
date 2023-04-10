Sample code to read data from .avro format 


```
# Reading .avro file 
# Avro install location: https://github.com/yanivru/PSAvroTools 
# Powershell module - https://www.powershellgallery.com/packages/AvroTools/1.3
# 	Recommend installing 1.3.9 version which includes schema extraction

# This code is to read all .avro files from given directory and list the content, add all errors into a file1, add all filtered content into file2

# $filespath = "C:\Users\parentfolderpath"
$filespath = "C:\Users\parentfolderpath\1.avro"
$files = Get-ChildItem -Path $filespath -Recurse | Where-Object {$_.Extension -eq ".avro"}

foreach($filename in $files){
    $dataavvrofile = Read-Avro  $filename 
    Write-Host "Processing - $($filename.FullName)"
    foreach($record in $dataavvrofile){

        try{
            $myobject = [System.Text.Encoding]::ASCII.GetString($record.Body) | ConvertFrom-Json 
        }
        catch{
            $mystring = [System.Text.Encoding]::ASCII.GetString($record.Body)
            Write-Host "*************** ERROR converting from JSON ****************"
            Write-Host $mystring
            $mystring >> "C:\Users\parentfolderpath\allresults.txt"
            if($mystring -like "*sfdadsf-sdf-safd-sadf-asdfsadf*"){
                $mystring >> "C:\Users\parentfolderpath\Filteredresults.txt"
            }
        }
        foreach($record in $myobject.records){
            if($null -ne $record.category){
                $record | Select-Object category,time,operationName,Properties
            }        
        }    
    }
}
```
