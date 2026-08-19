$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\")).Path
$files = Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.mbt" |
  Where-Object { $_.FullName -notmatch "[\\/]_build[\\/]" }
$production = 0
$tests = 0
$fixtures = 0
foreach ($file in $files) {
  $lines = (Get-Content -LiteralPath $file.FullName | Measure-Object -Line).Lines
  if ($file.Name -like "*_test.mbt") {
    $tests += $lines
  } elseif ($file.Name -like "*exhaustive*" -or $file.FullName -match "[\\/]cases[\\/]") {
    $fixtures += $lines
  } else {
    $production += $lines
  }
}
$total = $production + $tests + $fixtures
Write-Output "production_lines=$production"
Write-Output "test_lines=$tests"
Write-Output "fixture_lines=$fixtures"
Write-Output "in_scope_lines=$total"
if ($total -lt 20000) {
  throw "in-scope MoonBit line count $total is below the 20000-line acceptance threshold"
}
