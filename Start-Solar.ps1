$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
& (Get-Command node).Source (Join-Path $PSScriptRoot 'server.cjs')
