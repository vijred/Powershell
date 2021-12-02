Powershell - Windows Server
===========================

* Sample Commands ot see list of available counts 
```
Get-Counter -Counter "\Processor(*)\% Processor Time"
Get-Counter -ListSet Memory
Get-Counter -ListSet *
$c=Get-Counter -ListSet *
$c | Where-Object {$_.CounterSetName -contains "sql" }
$sqlc = $c | Where-Object {$_.CounterSetName -like "*SQL*" } | select counter
```

* How to update environment vatiables (PATH)
```
# Update User environment variable
$env:Path += ";C:\terraform" 

# Update system environment variable
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\terraform",
    [EnvironmentVariableTarget]::Machine)

# Update System environment variable in different way using registry
    $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
    $newpath = "$($DownloadPath);$oldpath"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath        
    (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path        

```

* Find Network ports opened 
```
$allconnections=Get-NetTCPConnection | Select-Object -Property *
$allconnections | Select-Object -Property CreationTime, RemotePort, RemoteAddress | Sort-Object -Property CreationTime
```

* Find if a port is open on a given server 
```
Test-NetConnection -ComputerName servername -Port portnumber
Test-NetConnection -ComputerName myserver.contoso.com -Port 3434
```

* Download commands
```
# Slow performance 
Invoke-WebRequest $install_url -OutFile $local_install_fullpath

# Performance similar to IE
$wc = New-Object net.webclient
$wc.Downloadfile($install_url, $local_install_fullpath)
```

* Unzip (Expand-Archive) fails with error, path is too long 
    -   use Registry edit to address the issue 
```    
if ( (Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem  -Name LongPathsEnabled).LongPathsEnabled -eq 0){
    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem  -Name LongPathsEnabled -value 1
}
```

* Run a job in the background 
    -   `start-job` can be used to invoke a job in the background - Example `Start-Job -Name PShellJob -ScriptBlock { Get-Process -Name PowerShell }`
    -   Ref: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/start-job?view=powershell-7.1


* How to provide inputs to an application from powershell 
    -   Reference : https://241931348f64b1d1.wordpress.com/2015/11/05/how-to-provide-input-to-applications-with-powershell/ 
    ```
    # Load Assebly System.Windows.Forms  
    [void] [System.Reflection.Assembly]::LoadWithPartialName(“‘System.Windows.Forms”)
    
    # Load NotePad
    & “$env:WINDIR\notepad.exe”
    
    # Wait the application start for 1 sec 
    Start-Sleep -m 1000
    
    # Send keys
    [System.Windows.Forms.SendKeys]::SendWait(“I'm wrinting something”)
    [System.Windows.Forms.SendKeys]::SendWait(“{ENTER}”)
    [System.Windows.Forms.SendKeys]::SendWait(“Powered by PowerShell”)
    
    # Open "Save As.." menu (Alt+f+s)
    [System.Windows.Forms.SendKeys]::SendWait(“%fs”)
    
    # Wait menu opening for 0.5 sec 
    Start-Sleep -m 500
    ```
    -   one more working sample that helped me to address java installation 
    ```
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    Start-Process -FilePath C:\myexecbatchfile.bat

    # Wait the application start for 2 sec 
    Start-Sleep -m 2000
    
    # Send keys
    [System.Windows.Forms.SendKeys]::SendWait("input1")
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    Start-Sleep -m 3000

    [System.Windows.Forms.SendKeys]::SendWait("input2")
    [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
    ```

* How to set path using powershell 
    -
    ```
    cd c:\
    set-item -path Env:CLASSPATH -value C:\Test 
    "CLASSPATH = $Env:CLASSPATH" 
    java.exe -classpath $Env:CLASSPATH HelloWorldApp
    ```

