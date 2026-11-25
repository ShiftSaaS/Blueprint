# PacRun.psm1 - shared helper for every PAC script run on Windows (standard: docs/execution/windows-scripts.md).
# A "run" = one execution of one script for one task. Output goes to <shared>\inbox\<TaskId>\<yyyyMMdd-HHmmss>\ with manifest.json.
# Never write passwords, keys or licence contents; use Protect-PacText on anything that may contain a connection string.

function Get-PacSharedRoot {
    if ($env:PAC_SHARED -and (Test-Path $env:PAC_SHARED)) { return $env:PAC_SHARED }
    if (Test-Path 'Z:\inbox') { return 'Z:\' }
    $here = Split-Path -Parent $PSScriptRoot   # module lives in <shared>\lib -> its parent is the shared root
    if (Test-Path (Join-Path $here 'inbox')) { return $here }
    throw 'PAC shared folder not found. Map it as Z: (\\<Mac IP>\shared) or set $env:PAC_SHARED.'
}

function Protect-PacText([string]$Text) {
    $t = $Text -replace '(?i)(password|pwd)\s*=\s*[^;"''\s]*', '$1=***'
    $t = $t -replace '(?i)(/SAPWD=)\S+', '$1***'
    return $t
}

function Start-PacRun {
    param([Parameter(Mandatory)][string]$TaskId, [string]$Script = $MyInvocation.PSCommandPath)
    $root  = Get-PacSharedRoot
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $dir   = Join-Path $root "inbox\$TaskId\$stamp"
    New-Item -ItemType Directory -Force $dir | Out-Null
    $run = [pscustomobject]@{
        TaskId = $TaskId; Script = (Split-Path -Leaf $Script); Dir = $dir; SharedRoot = $root
        Machine = $env:COMPUTERNAME; User = "$env:USERDOMAIN\$env:USERNAME"
        IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        Started = (Get-Date).ToString('o'); Steps = New-Object System.Collections.ArrayList
    }
    Write-PacLog $run "=== $($run.Script) started for $TaskId on $($run.Machine) ==="
    return $run
}

function Write-PacLog($Run, [string]$Message) {
    $line = '{0:yyyy-MM-dd HH:mm:ss}  {1}' -f (Get-Date), (Protect-PacText $Message)
    Write-Host $line
    Add-Content (Join-Path $Run.Dir 'run-log.txt') $line
}

function Save-PacOutput($Run, [string]$Name, [scriptblock]$Block) {
    $file = Join-Path $Run.Dir $Name
    try { $text = & $Block 2>&1 | Out-String -Width 220; $ok = $true } catch { $text = "ERROR: $_"; $ok = $false }
    Protect-PacText $text | Out-File $file -Encoding utf8
    [void]$Run.Steps.Add([pscustomobject]@{ file = $Name; ok = $ok })
    Write-PacLog $Run ("wrote {0}{1}" -f $Name, $(if ($ok) { '' } else { '  (ERROR inside)' }))
}

function Complete-PacRun($Run, [int]$ExitCode = 0) {
    Write-PacLog $Run "=== finished, exit code $ExitCode ==="
    $files = Get-ChildItem $Run.Dir -File | Where-Object Name -ne 'manifest.json' | Sort-Object Name | ForEach-Object {
        [ordered]@{ name = $_.Name; bytes = $_.Length; sha256 = (Get-FileHash $_.FullName -Algorithm SHA256).Hash } }
    $manifest = [ordered]@{
        task = $Run.TaskId; script = $Run.Script; machine = $Run.Machine; user = $Run.User; isAdmin = $Run.IsAdmin
        started = $Run.Started; finished = (Get-Date).ToString('o'); exitCode = $ExitCode
        steps = $Run.Steps; files = $files; standard = 'docs/execution/windows-scripts.md v1'
    }
    $manifest | ConvertTo-Json -Depth 5 | Out-File (Join-Path $Run.Dir 'manifest.json') -Encoding utf8
    Write-Host ""
    Write-Host "Run saved to $($Run.Dir)" -ForegroundColor Green
    Write-Host "Now type in the chat:  added $($Run.TaskId)" -ForegroundColor Green
}

Export-ModuleMember -Function Get-PacSharedRoot, Protect-PacText, Start-PacRun, Write-PacLog, Save-PacOutput, Complete-PacRun
