$logPath = '.\contstats.csv'
$timer = New-Object -Type Timers.Timer
$timer.AutoReset = $false
$timer.Interval = 1 * 60 * 60 * 1000 # time to collect in ms
$timer.Start()

$finalTime = (Get-Date).AddMilliseconds($timer.Interval)

While ($timer.Enabled)
{
    $progress = New-TimeSpan (Get-Date) -End $finalTime
    Write-Progress -Activity "Logging container performance to $logPath" -SecondsRemaining $progress.TotalSeconds

    $timestamp = Get-Date -Format u
    "$timestamp,$(docker stats --all --no-stream --format "{{.Container}},{{.Name}},{{.CPUPerc}},{{.MemUsage}},{{.NetIO}}")" >> $logPath
}

Write-Host "Perfomance metrics has been collected"
