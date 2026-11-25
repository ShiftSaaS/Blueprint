# P0.2 - round-trip test of the Windows <-> Mac exchange (read-only; changes nothing on the machine).
# Class: 🟡 RUN (read-only) — see docs/execution/windows-scripts.md § Approval classes.
# Run from the mapped share:   powershell -ExecutionPolicy Bypass -File Z:\outbox\P0.2\P0.2-roundtrip.ps1
# Writes Z:\inbox\P0.2\<run>\ with 01-transport.txt, 02-layout.txt, 03-hello-from-windows.txt, run-log.txt, manifest.json.

Import-Module (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'lib\PacRun.psm1') -Force
$run = Start-PacRun -TaskId 'P0.2' -Script $PSCommandPath

Save-PacOutput $run '01-transport.txt' {
    "Shared root: $($run.SharedRoot)"
    "--- SMB mappings:"; Get-SmbMapping -ErrorAction SilentlyContinue | Format-Table LocalPath, RemotePath, Status -AutoSize
    $unc = (Get-SmbMapping -LocalPath 'Z:' -ErrorAction SilentlyContinue).RemotePath
    if ($unc) {
        $macHost = ($unc -split '\\')[2]
        "--- Test-NetConnection $macHost -Port 445:"
        Test-NetConnection $macHost -Port 445 -WarningAction SilentlyContinue | Select-Object ComputerName, RemoteAddress, TcpTestSucceeded | Format-List
    }
    "--- Marker written by the Mac (outbox\P0.2\hello-from-mac.txt):"
    $m = Join-Path $run.SharedRoot 'outbox\P0.2\hello-from-mac.txt'
    if (Test-Path $m) { Get-Content $m } else { 'NOT FOUND' }
}

Save-PacOutput $run '02-layout.txt' {
    Get-ChildItem $run.SharedRoot -Recurse -Depth 2 -ErrorAction SilentlyContinue |
        Select-Object @{n='Path';e={$_.FullName.Substring($run.SharedRoot.Length)}}, Length, LastWriteTime | Format-Table -AutoSize
}

Save-PacOutput $run '03-hello-from-windows.txt' { "Hello from $env:COMPUTERNAME at $(Get-Date -Format o)" }

Complete-PacRun $run 0
