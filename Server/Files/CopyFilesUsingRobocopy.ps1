
# Copy file using Robocopy with given filter criteria 

$sourceFolder = "C:\xyz\VJHandyDandy\"
$DestinationFolder =  "C:\temp\delete\TestNewRepo\"
$ExcludeStringCriteria = "msft"

$AllFiles = get-childitem $sourceFolder -R | Where-Object {$_.FullName -notmatch $ExcludeStringCriteria} 

foreach($obj in $AllFiles)
{
	if ($obj.Attributes -eq "Directory"){
		robocopy $obj.FullName ($obj.FullName).Replace($sourceFolder,$DestinationFolder) /XO /xx /xf *
	}
	else{
		robocopy $obj.Directory.FullName ($obj.Directory.FullName).Replace($sourceFolder,$DestinationFolder) $obj.Name -XO 
	}
}
