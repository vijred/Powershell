# Sample powershell to read data from Json format, save selected columns in .csv format

$files = Get-ChildItem -Path C:\Users\Vijay\FirbitArchiveCustomPath\sleep-*.json | Sort-Object FullName
foreach ($file in $files) {
	Get-Content -Raw $($file.FullName) | ConvertFrom-Json | Sort-Object dateOfSleep | Select dateOfSleep, duration, minutesToFallAsleep, minutesAsleep, minutesAwake, minutesAfterWakeup, timeInBed, efficiency,  infoCode, logType | Export-Csv sleepData.csv -Append
}

# Note: In this example you are reading all files with the pattern `C:\Users\Vijay\FirbitArchiveCustomPath\sleep-*.json` and saving them to `sleepData.csv`

#fitbit
#dataarchive
#convert
