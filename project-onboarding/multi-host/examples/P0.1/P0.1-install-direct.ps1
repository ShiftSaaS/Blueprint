# P0.1 - install VS 2022 Build Tools and 7-Zip DIRECTLY (no winget; winget hung twice on LAPTOP-02F3MKEV).
# IIS is already done by P0.1-install.ps1. SSMS and SQL Server 2019 are installed manually afterwards.
# Run in PowerShell "as Administrator":
#   powershell -ExecutionPolicy Bypass -File .\P0.1-install-direct.ps1
# Log: Desktop\P0.1-evidence\install-log.txt (appended).

$ErrorActionPreference = 'Stop'
$out = Join-Path $env:USERPROFILE 'Desktop\P0.1-evidence'; New-Item -ItemType Directory -Force $out | Out-Null
$log = Join-Path $out 'install-log.txt'
function Log($m) { $line = "{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m; Write-Host $line; Add-Content $log $line }
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'Run this in PowerShell opened with "Run as administrator".' -ForegroundColor Red; exit 1 }

$dl = 'D:\PAC\installers'; New-Item -ItemType Directory -Force $dl | Out-Null
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'   # makes Invoke-WebRequest much faster
Log "=== P0.1 direct install started (no winget) ==="
Log ("C: free before = {0} GB" -f [math]::Round((Get-PSDrive C).Free/1GB,1))

# ---------- VS 2022 Build Tools ----------
$vsExe = Join-Path $dl 'vs_buildtools.exe'
try {
    Log "VS   downloading bootstrapper from https://aka.ms/vs/17/release/vs_buildtools.exe"
    Invoke-WebRequest 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile $vsExe -UseBasicParsing
    Log ("VS   bootstrapper saved, {0} KB. Installing to D:\VS\2022\BuildTools (15-40 min; progress window may appear)" -f [int]((Get-Item $vsExe).Length/1KB))
    $vsArgs = @('--passive','--wait','--norestart','--nocache',
                '--installPath','D:\VS\2022\BuildTools',
                '--add','Microsoft.VisualStudio.Workload.MSBuildTools',
                '--add','Microsoft.VisualStudio.Workload.WebBuildTools',
                '--add','Microsoft.Net.Component.4.8.SDK',
                '--add','Microsoft.Net.Component.4.8.TargetingPack',
                '--includeRecommended')
    $p = Start-Process -FilePath $vsExe -ArgumentList $vsArgs -Wait -PassThru
    Log "VS   exit code $($p.ExitCode)   (0 = success, 3010 = success but restart needed)"
} catch { Log "VS   FAILED: $_" }

# ---------- 7-Zip ----------
$zExe = Join-Path $dl '7z-x64.exe'
try {
    if ((Test-Path "$env:ProgramFiles\7-Zip\7z.exe")) { Log "7Z   already installed" }
    else {
        Log "7Z   downloading https://www.7-zip.org/a/7z2409-x64.exe"
        Invoke-WebRequest 'https://www.7-zip.org/a/7z2409-x64.exe' -OutFile $zExe -UseBasicParsing
        $p = Start-Process -FilePath $zExe -ArgumentList '/S' -Wait -PassThru
        Log "7Z   exit code $($p.ExitCode); present=$(Test-Path "$env:ProgramFiles\7-Zip\7z.exe")"
    }
} catch { Log "7Z   FAILED: $_" }

Log ("C: free after = {0} GB" -f [math]::Round((Get-PSDrive C).Free/1GB,1))
Log "=== P0.1 direct install finished ==="
Write-Host "`nNext: install SSMS and SQL Server 2019 Developer manually (see chat), then run P0.1-check-workstation-v2.ps1." -ForegroundColor Green
