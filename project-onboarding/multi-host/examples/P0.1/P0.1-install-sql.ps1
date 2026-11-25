# P0.1 - install SQL Server 2019 Developer (Database Engine only, mixed mode, data on D:, memory capped at 1024 MB)
#        and download + launch the SSMS installer.
# Owner checks: I = 1 (light setup), G = SQL Server 2019 Developer.
# Run in PowerShell "as Administrator":
#   powershell -ExecutionPolicy Bypass -File .\P0.1-install-sql.ps1
# The sa password is typed by you at a hidden prompt; it is NEVER written to the log or the screen.
# Log: Desktop\P0.1-evidence\install-log.txt (appended).

$ErrorActionPreference = 'Stop'
$out = Join-Path $env:USERPROFILE 'Desktop\P0.1-evidence'; New-Item -ItemType Directory -Force $out | Out-Null
$log = Join-Path $out 'install-log.txt'
function Log($m) { $line = "{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m; Write-Host $line; Add-Content $log $line }
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'Run this in PowerShell opened with "Run as administrator".' -ForegroundColor Red; exit 1 }

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
$dl    = 'D:\PAC\installers'
$sqlDl = Join-Path $dl 'SQL2019'
$media = Join-Path $sqlDl 'media'
New-Item -ItemType Directory -Force $sqlDl, 'D:\SQLData' | Out-Null
Log "=== P0.1 SQL Server 2019 install started ==="

if (Get-Service MSSQLSERVER -ErrorAction SilentlyContinue) {
    Log "SQL  default instance MSSQLSERVER already exists - skipping install"
} else {
    # 1. Download the SQL Server 2019 Developer web installer (SSEI)
    $ssei = Join-Path $dl 'SQL2019-SSEI-Dev.exe'
    if (-not (Test-Path $ssei)) {
        Log "SQL  downloading SSEI from https://go.microsoft.com/fwlink/?linkid=866662"
        Invoke-WebRequest 'https://go.microsoft.com/fwlink/?linkid=866662' -OutFile $ssei -UseBasicParsing
    }
    # 2. Let SSEI download the full media (CAB) to D:
    if (-not (Get-ChildItem $sqlDl -Filter 'SQLServer2019-*.exe' -ErrorAction SilentlyContinue)) {
        Log "SQL  downloading installation media to $sqlDl (about 1.5 GB, several minutes)"
        $p = Start-Process $ssei -ArgumentList '/ACTION=Download', "/MEDIAPATH=$sqlDl", '/MEDIATYPE=CAB', '/QUIET' -Wait -PassThru
        Log "SQL  SSEI download exit code $($p.ExitCode)"
    }
    $cab = Get-ChildItem $sqlDl -Filter 'SQLServer2019-*.exe' | Select-Object -First 1
    if (-not $cab) { Log "SQL  FAILED: media not found in $sqlDl. Install manually with the GUI (see chat)."; exit 2 }
    # 3. Extract the media
    if (-not (Test-Path (Join-Path $media 'setup.exe'))) {
        Log "SQL  extracting $($cab.Name) to $media"
        $p = Start-Process $cab.FullName -ArgumentList '/q', "/x:$media" -Wait -PassThru
        Log "SQL  extract exit code $($p.ExitCode)"
    }
    # 4. Ask for the sa password (hidden, never logged)
    do {
        $s1 = Read-Host 'Choose the sa password (min 8 chars, upper+lower+digit+symbol)' -AsSecureString
        $s2 = Read-Host 'Type it again' -AsSecureString
        $p1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s1))
        $p2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($s2))
        $okPwd = ($p1 -eq $p2) -and ($p1.Length -ge 8)
        if (-not $okPwd) { Write-Host 'Passwords differ or shorter than 8 characters. Try again.' -ForegroundColor Yellow }
    } until ($okPwd)
    # 5. Unattended install: Database Engine only, default instance, mixed mode, data on D:
    Log "SQL  installing Database Engine (default instance, mixed mode, data root D:\SQLData) - 10-25 min"
    Write-Host 'SQL Setup is running. A progress window may appear: do NOT close it and do not press keys here until it finishes.' -ForegroundColor Yellow
    $setupArgs = @('/QS','/ACTION=Install','/IACCEPTSQLSERVERLICENSETERMS','/FEATURES=SQLENGINE',
                   '/INSTANCENAME=MSSQLSERVER','/SECURITYMODE=SQL',"/SAPWD=`"$p1`"",
                   '/SQLSYSADMINACCOUNTS="BUILTIN\Administrators"',
                   '/INSTALLSQLDATADIR="D:\SQLData"','/TCPENABLED=1','/UPDATEENABLED=False')
    # v2: -NoNewWindow keeps setup in THIS console (attempt 1 ran in a separate console and was interrupted: 0xC000013A).
    $p = Start-Process (Join-Path $media 'setup.exe') -ArgumentList $setupArgs -Wait -PassThru -NoNewWindow
    $p1 = $null; $p2 = $null
    Log "SQL  setup exit code $($p.ExitCode)   (0 = success, 3010 = success but restart needed)"
    if ($p.ExitCode -notin 0, 3010) {
        Log "SQL  see the setup log: C:\Program Files\Microsoft SQL Server\150\Setup Bootstrap\Log\Summary.txt"
        exit 3
    }
}

# 6. Cap memory at 1024 MB (owner check I = 1)
$sq = (Get-Command sqlcmd -ErrorAction SilentlyContinue).Source
if (-not $sq) { $sq = (Get-ChildItem 'C:\Program Files\Microsoft SQL Server' -Recurse -Filter SQLCMD.EXE -ErrorAction SilentlyContinue | Select-Object -First 1).FullName }
if ($sq) {
    & $sq -S . -E -b -Q "EXEC sp_configure 'show advanced options',1; RECONFIGURE; EXEC sp_configure 'max server memory (MB)',1024; RECONFIGURE;" | Out-Null
    Log "SQL  max server memory set to 1024 MB (sqlcmd exit $LASTEXITCODE)"
} else { Log "SQL  sqlcmd not found - memory cap NOT applied (do it in SSMS: Server Properties > Memory > 1024)" }

# 7. SSMS: download and open its installer (click Install)
$ssms = Join-Path $dl 'SSMS-Setup-ENU.exe'
$haveSsms = Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object DisplayName -like '*Management Studio*'
if ($haveSsms) { Log "SSMS already installed: $($haveSsms[0].DisplayName) $($haveSsms[0].DisplayVersion)" }
else {
    try {
        Log "SSMS downloading https://aka.ms/ssmsfullsetup"
        Invoke-WebRequest 'https://aka.ms/ssmsfullsetup' -OutFile $ssms -UseBasicParsing
        Log "SSMS installer saved to $ssms - opening it now; click Install and wait for it to finish"
        Start-Process $ssms -Wait
        Log "SSMS installer closed"
    } catch { Log "SSMS FAILED to download: $_  (download SSMS manually from Microsoft's site)" }
}

Log ("C: free after = {0} GB" -f [math]::Round((Get-PSDrive C).Free/1GB,1))
Log "=== P0.1 SQL Server 2019 install finished ==="
Write-Host "`nNext: restart Windows if setup said 3010, then run P0.1-check-workstation-v2.ps1 and paste ALL.txt." -ForegroundColor Green
