Start-Transcript "C:\Users\Public\Transcript_$(Get-Date -f MM-dd-yyyy_HHmmss).txt"

$(Get-Date) 
Write-host "Testing only from Debug" 

Write-host "PSVersion: " 
$PSVersionTable 

Write-host "Computername: " 
$env:COMPUTERNAME 

Write-host "Username, Domain, UserDNSDomain: " 
$env:USERNAME 
$env:USERDOMAIN 
$env:USERDNSDOMAIN 

Write-host "Env path: " 
$env:Path 

Write-host "Script location: " 
$PSScriptRoot 

"$(Get-Date) - Started installing Azure CLI" 
$ProgressPreference = 'SilentlyContinue'; 
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; 
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; 
rm .\AzureCLI.msi
"$(Get-Date) -Azure CLI insall completed" 


"$(Get-Date) - Started installing NuGet Module" 
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

"$(Get-Date) - Started installing AZ Module" 
Install-Module -Name Az -Repository PSGallery -Force -RequiredVersion 3.1.0 
"$(Get-Date) - Completed installing AZ Module" 

"$(Get-Date) - Started  Terraform install" 

    # Terrafrom download Url
    $Url = 'https://www.terraform.io/downloads.html'
 
    # Local path to download the terraform zip file
    $DownloadPath = 'C:\Terraform\'
 
    # Create the local folder if it doesn't exist
    if ((Test-Path -Path $DownloadPath) -eq $false) { $null = New-Item -Path $DownloadPath -ItemType Directory -Force }

"$(Get-Date) - Created path, started downloading" 
    
    # # Alternative fix to avoid -UseBasicParsing ; This avoids error: The response content cannot be parsed because the Internet Explorer engine is not available
    # # Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2
    # Download the Terraform exe in zip format
    $Web = Invoke-WebRequest -Uri $Url -UseBasicParsing
"$(Get-Date) - Invoke-WebRequest -Uri $Url - Completed" 

"$(Get-Date) - Sleep for 10 seconds started" 
    Start-Sleep -Seconds 10

$FileInfo = $Web.Links | Where-Object href -match windows_amd64

"$(Get-Date) - FileInfoLink - Completed, DownloadLink assignment started" 
    $DownloadLink = $FileInfo.href

"$(Get-Date) - FileInfoLink - Completed, Filename assigned" 
    $FileName = Split-Path -Path $DownloadLink -Leaf

"$(Get-Date) - Download started"

    $DownloadFile = [string]::Concat( $DownloadPath, $FileName )
    Invoke-RestMethod -Method Get -Uri $DownloadLink -OutFile $DownloadFile
 
    # Extract & delete the zip file
    Expand-Archive -Path $DownloadFile -DestinationPath $DownloadPath -Force
    Remove-Item -Path $DownloadFile -Force
 
    # Setting the persistent path in the registry if it is not set already
    if ($DownloadPath -notin $($ENV:Path -split ';'))
    {
		$path = [Environment]::GetEnvironmentVariable('PATH', 'Machine')
        Write-Host "Old Path is - $path"
        if($path[-1] -eq ';'){
                $path += "$($DownloadPath);"
        } else {
            $path += ";$($DownloadPath)"
        }
        Write-Host "New Path is - $path"
		[Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')
        # $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
        # $newpath = "$($DownloadPath);$oldpath"
        # Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath        
        # (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path        
        $env:Path += ";$($DownloadPath)"
    }
 
    # Verify the download
    Invoke-Expression -Command "terraform version"

"$(Get-Date) - Terraform install - Completed" 


Stop-transcript 
