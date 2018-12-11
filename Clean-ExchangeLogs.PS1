<# Changes tracking
v1.1 - replaced $Files = Get-ChildItem "C:\Program Files\Microsoft\Exchange\..." with Get-ChildItem $TargetFolder argument
v1.2 - replaced Write-Host "Deleting file ..." with progress bar
#>
# Set-Executionpolicy RemoteSigned
$days=0
$IISLogPath="C:\inetpub\logs\LogFiles\"
$ExchangeLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Logging\"
$ETLLoggingPath="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\ETLTraces\"
$ETLLoggingPath2="C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\Logs"
Function CleanLogfiles($TargetFolder)
{
  write-host -debug -ForegroundColor Yellow -BackgroundColor Cyan $TargetFolder

    if (Test-Path $TargetFolder) {
        $Now = Get-Date
        $LastWrite = $Now.AddDays(-$days)
        $Files = Get-ChildItem $TargetFolder  -Recurse | Where-Object {$_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl"}  | where {$_.lastWriteTime -le "$lastwrite"} | Select-Object FullName  
        $Counter = 0
        foreach ($File in $Files)
            {
                $ProgressMessage = "Deleting file $FullFileName"
                Write-Progress -Activity "Deleting files" -Status $ProgressMessage -Id 1 -PercentComplete $($Counter/$($Files.count)*100)
                $FullFileName = $File.FullName
                Remove-Item $FullFileName -ErrorAction SilentlyContinue | out-null
                $counter++
            }
       }
Else {
    Write-Host "The folder $TargetFolder doesn't exist! Check the folder path!" -ForegroundColor "red"
    }
}
CleanLogfiles($IISLogPath)
CleanLogfiles($ExchangeLoggingPath)
CleanLogfiles($ETLLoggingPath)
CleanLogfiles($ETLLoggingPath2)