# P0.1 - read-only workstation check, v2 (light setup: VS 2022 Build Tools, SQL Server 2019 with memory cap).
# Installs nothing, changes nothing. Run in PowerShell "as Administrator":
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\P0.1-check-workstation-v2.ps1"
# Output: Desktop\P0.1-evidence\01..08-*.txt and ALL.txt (paste ALL.txt into the chat). No passwords or keys are read.

$out = Join-Path $env:USERPROFILE 'Desktop\P0.1-evidence'
New-Item -ItemType Directory -Force $out | Out-Null
function Save($name, [scriptblock]$block) {
    $file = Join-Path $out $name
    try { & $block 2>&1 | Out-String -Width 220 | Out-File $file -Encoding utf8 } catch { "ERROR: $_" | Out-File $file -Encoding utf8 }
    Write-Host "  wrote $name"
}
function Find-Sqlcmd {
    $c = Get-Command sqlcmd -ErrorAction SilentlyContinue; if ($c) { return $c.Source }
    $p = Get-ChildItem 'C:\Program Files\Microsoft SQL Server' -Recurse -Filter SQLCMD.EXE -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($p) { return $p.FullName }; return $null
}
Write-Host "P0.1 check v2 -> $out"

Save '01-windows.txt' {
    Get-ComputerInfo -Property WindowsProductName, WindowsEditionId, WindowsVersion, OsBuildNumber, OsArchitecture | Format-List
    "PROCESSOR_ARCHITECTURE=$env:PROCESSOR_ARCHITECTURE"; "Model=" + (Get-CimInstance Win32_ComputerSystem).Model
}
Save '02-admin.txt' {
    "User=$env:USERDOMAIN\$env:USERNAME"
    "IsAdmin=" + ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
Save '03-hardware.txt' {
    "RAM_GB={0:N1}" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{n='FreeGB'; e={[math]::Round($_.Free / 1GB, 1)}}, @{n='UsedGB'; e={[math]::Round($_.Used / 1GB, 1)}} | Format-Table -AutoSize
}
Save '04-visualstudio.txt' {
    $vw = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vw) {
        "--- All Visual Studio products (incl. Build Tools):"
        & $vw -all -products * -format text | Select-String 'displayName|installationVersion|installationPath|productId'
        "--- Products WITH WebBuildTools workload + .NET 4.8 targeting pack + .NET 4.8 SDK:"
        $ok = & $vw -all -products * -requires Microsoft.VisualStudio.Workload.WebBuildTools Microsoft.Net.Component.4.8.TargetingPack Microsoft.Net.Component.4.8.SDK -property installationPath
        if ($ok) { $ok } else { '(none)' }
        "--- MSBuild.exe path(s):"; & $vw -all -products * -find 'MSBuild\**\Bin\MSBuild.exe'
        "--- WebApplication targets (needed by the Web Forms projects):"
        Get-ChildItem (& $vw -all -products * -property installationPath) -Recurse -Filter 'Microsoft.WebApplication.targets' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
    } else { 'Visual Studio / Build Tools: NOT FOUND (no vswhere.exe)' }
}
Save '05-netfx.txt' {
    $r = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -ErrorAction SilentlyContinue).Release
    "NetFx4 Release=$r   (>= 528040 means .NET Framework 4.8 or later)"
    "--- Targeting packs present:"
    Get-ChildItem "${env:ProgramFiles(x86)}\Reference Assemblies\Microsoft\Framework\.NETFramework" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
}
Save '06-iis.txt' {
    Get-WindowsOptionalFeature -Online | Where-Object { $_.FeatureName -like 'IIS-*' -and $_.State -eq 'Enabled' } | Sort-Object FeatureName | Format-Table FeatureName, State -AutoSize
    try { Import-Module WebAdministration -ErrorAction Stop; 'WebAdministration module: OK'; Get-Website | Format-Table Name, State, PhysicalPath -AutoSize } catch { "WebAdministration module: FAILED - $_" }
    "W3SVC service: " + (Get-Service W3SVC -ErrorAction SilentlyContinue).Status
}
Save '07-sqlserver.txt' {
    "--- SQL Server services:"
    Get-Service -Name 'MSSQL*', 'SQLAgent*' -ErrorAction SilentlyContinue | Format-Table Name, Status, StartType -AutoSize
    $sq = Find-Sqlcmd
    if ($sq) {
        "sqlcmd=$sq"
        & $sq -S . -E -l 5 -W -Q "SET NOCOUNT ON; SELECT @@VERSION; SELECT 'IsIntegratedSecurityOnly=' + CAST(SERVERPROPERTY('IsIntegratedSecurityOnly') AS varchar(5)) + '  (0 = mixed mode)'; SELECT 'max server memory (MB)=' + CAST(value_in_use AS varchar(20)) FROM sys.configurations WHERE name = 'max server memory (MB)'; SELECT 'DefaultDataPath=' + CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(260)); SELECT 'DefaultLogPath=' + CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS nvarchar(260))"
    } else { 'sqlcmd: NOT FOUND' }
    "--- SSMS:"
    Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue |
        Where-Object DisplayName -like '*Management Studio*' | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
}
Save '08-git-7zip.txt' {
    try { git --version } catch { 'git: NOT FOUND' }
    "7-Zip present=" + ((Test-Path "$env:ProgramFiles\7-Zip\7z.exe") -or (Test-Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe"))
    "Telerik licence file present=" + (Test-Path "$env:APPDATA\Telerik\telerik-license.txt") + "   (presence only; expected False until P0.10)"
}
$all = Join-Path $out 'ALL.txt'
Get-ChildItem $out -Filter '0*.txt' | Sort-Object Name | ForEach-Object { "===== $($_.Name) ====="; Get-Content $_.FullName; '' } | Out-File $all -Encoding utf8
$logf = Join-Path $out 'install-log.txt'
if (Test-Path $logf) { "===== install-log.txt =====" | Add-Content $all; Get-Content $logf | Add-Content $all }
Write-Host "`nDone. Paste the content of $all into the chat."
Start-Process notepad.exe $all
