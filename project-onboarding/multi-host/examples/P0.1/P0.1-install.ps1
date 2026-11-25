# P0.1 - install the PAC local toolchain, LIGHT SETUP (owner check I = 1) on LAPTOP-02F3MKEV.
# Installs: IIS features (PAC handover doc 1 §3.2 + IIS Management Scripts and Tools), VS 2022 Build Tools (web + .NET 4.8),
#           7-Zip, SQL Server Management Studio.  SQL Server 2019 Developer is installed MANUALLY (see the chat steps).
# Run in PowerShell "as Administrator":
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\P0.1-install.ps1"
# Re-running is safe: each step skips what is already present. A log is written to Desktop\P0.1-evidence\install-log.txt.

$ErrorActionPreference = 'Continue'
$out = Join-Path $env:USERPROFILE 'Desktop\P0.1-evidence'
New-Item -ItemType Directory -Force $out | Out-Null
$log = Join-Path $out 'install-log.txt'
function Log($m) { $line = "{0:yyyy-MM-dd HH:mm:ss}  {1}" -f (Get-Date), $m; Write-Host $line; Add-Content $log $line }

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'Please run this script in PowerShell opened with "Run as administrator".' -ForegroundColor Red; exit 1
}
Log "=== P0.1 install started on $env:COMPUTERNAME ==="
$freeC = [math]::Round((Get-PSDrive C).Free / 1GB, 1); Log "C: free before = $freeC GB"
if ($freeC -lt 12) { Log 'WARNING: C: has less than 12 GB free. Free up space (Disk Cleanup, Downloads) before continuing.'; }

# ---------- 1. IIS features ----------
$iis = @(
  'IIS-WebServerRole','IIS-WebServer','IIS-CommonHttpFeatures','IIS-StaticContent','IIS-DefaultDocument','IIS-HttpErrors',
  'IIS-ApplicationDevelopment','IIS-NetFxExtensibility45','IIS-ISAPIExtensions','IIS-ISAPIFilter','IIS-ASPNET45',
  'IIS-Security','IIS-RequestFiltering','IIS-HealthAndDiagnostics','IIS-HttpLogging',
  'IIS-WebServerManagementTools','IIS-ManagementConsole','IIS-ManagementScriptingTools'
)
$restart = $false
foreach ($f in $iis) {
    $feat = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
    # Note: State 'Disabled' is enum value 0, so test the object for $null, never "-not $state".
    if ($null -eq $feat) { Log "IIS  $f NOT OFFERED on this Windows edition"; continue }
    if ("$($feat.State)" -eq 'Enabled') { Log "IIS  $f already enabled"; continue }
    $r = Enable-WindowsOptionalFeature -Online -FeatureName $f -All -NoRestart -ErrorAction SilentlyContinue
    if ($r) { Log "IIS  $f enabled"; if ($r.RestartNeeded) { $restart = $true } } else { Log "IIS  $f FAILED: $($Error[0])" }
}

# ---------- 2. winget packages ----------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log 'winget NOT FOUND - update "App Installer" from the Microsoft Store, then re-run this script.'
} else {
    Log ("winget version: " + (winget --version))
    function WingetInstall($id, $extra) {
        # v3: no "winget list" pre-check (it hung on this laptop); winget install itself reports an existing install.
        Log "PKG  installing $id ... (Build Tools can take 15-40 min with no screen output)"
        $wargs = @('install','--id',$id,'-e','--accept-package-agreements','--accept-source-agreements','--silent') + $extra
        & winget @wargs 2>&1 | Out-String | Add-Content $log
        Log "PKG  $id winget exit code $LASTEXITCODE"
    }
    # VS 2022 Build Tools on D: (shared components still use some space on C:)
    $vsArgs = '--quiet --wait --norestart --nocache --installPath "D:\VS\2022\BuildTools" ' +
              '--add Microsoft.VisualStudio.Workload.MSBuildTools ' +
              '--add Microsoft.VisualStudio.Workload.WebBuildTools ' +
              '--add Microsoft.Net.Component.4.8.SDK --add Microsoft.Net.Component.4.8.TargetingPack ' +
              '--includeRecommended'
    WingetInstall 'Microsoft.VisualStudio.2022.BuildTools' @('--override', $vsArgs)
    WingetInstall '7zip.7zip' @()
    WingetInstall 'Microsoft.SQLServerManagementStudio' @()
}

$freeC = [math]::Round((Get-PSDrive C).Free / 1GB, 1); Log "C: free after = $freeC GB"
Log "=== P0.1 install finished. Restart needed: $restart ==="
if ($restart) { Write-Host "`nRestart Windows now, then continue with the SQL Server 2019 steps." -ForegroundColor Yellow }
else { Write-Host "`nContinue with the SQL Server 2019 steps." -ForegroundColor Green }
