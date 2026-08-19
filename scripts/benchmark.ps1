$ErrorActionPreference = "Stop"
$samples = 100
$sw = [System.Diagnostics.Stopwatch]::StartNew()
for ($i = 0; $i -lt $samples; $i++) {
  $eye = 1 + ($i % 4)
  $verbal = 1 + ($i % 5)
  $motor = 1 + ($i % 6)
  moon run cmd/main -- calc gcs $eye $verbal $motor | Out-Null
}
$sw.Stop()
$seconds = [Math]::Max($sw.Elapsed.TotalSeconds, 0.000001)
Write-Output "moonbit-neuroscore benchmark"
moon version
Write-Output ("samples={0} elapsed_ms={1:N2} requests_per_second={2:N2}" -f $samples, $sw.Elapsed.TotalMilliseconds, ($samples / $seconds))
