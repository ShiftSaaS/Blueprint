# P0.1 - read-only workstation check for PAC Online local setup.
# Installs nothing, changes nothing. Run in PowerShell "as Administrator":
#   powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\P0.1-check-workstation.ps1"
# Output: Desktop\P0.1-evidence\01..08-*.txt and ALL.txt (all results in one file, for pasting into chat).
# No passwords, keys or licence contents are read or written.

$out = Join-Path $env:USERPROFILE 'Desktop\P0.1-evidence'
New-Item -ItemType Directory -Force $out | Out-Null

function Save($name, [scriptblock]$block) {
    $file = Join-Path $out $name
    try { & $block 2>&1 | Out-String -Width 220 | Out-File $file -Encoding utf8 }
    catch { "ERROR: $_" | Out-File $file -Encoding utf8 }
    Write-Host "  wrote $name"
}

Write-Host "P0.1 check -> $out"

Save '01-windows.txt' {
    Get-ComputerInfo -Property WindowsProductName, WindowsEditionId, WindowsVersion, OsBuildNumber, OsArchitecture | Format-List
    "PROCESSOR_ARCHITECTURE=$env:PROCESSOR_ARCHITECTURE"
    "Model=" + (Get-CimInstance Win32_ComputerSystem).Model
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
        "--- All Visual Studio installs:"
        & $vw -all -products * -format text | Select-String 'displayName|installationVersion|installationPath|productId'
        "--- Installs that HAVE ASP.NET workload + .NET 4.8 targeting pack + .NET 4.8 SDK:"
        $ok = & $vw -all -products * -requires Microsoft.VisualStudio.Workload.NetWeb Microsoft.Net.Component.4.8.TargetingPack Microsoft.Net.Component.4.8.SDK -property installationPath
        if ($ok) { $ok } else { '(none)' }
        "--- MSBuild.exe path(s):"
        & $vw -all -products * -find 'MSBuild\**\Bin\MSBuild.exe'
    } else { 'Visual Studio: NOT FOUND (no vswhere.exe)' }
}

Save '05-netfx.txt' {
    $r = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -ErrorAction SilentlyContinue).Release
    "NetFx4 Release=$r   (>= 528040 means .NET Framework 4.8 or later)"
    "--- Targeting packs present:"
    Get-ChildItem "${env:ProgramFiles(x86)}\Reference Assemblies\Microsoft\Framework\.NETFramework" -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
}

Save '06-iis.txt' {
    Get-WindowsOptionalFeature -Online | Where-Object FeatureName -like 'IIS-*' | Sort-Object FeatureName | Format-Table FeatureName, State -AutoSize
    try { Import-Module WebAdministration -ErrorAction Stop; 'WebAdministration module: OK' } catch { "WebAdministration module: FAILED - $_" }
}

Save '07-sqlserver.txt' {
    "--- SQL Server services:"
    Get-Service -Name 'MSSQL*', 'SQLAgent*' -ErrorAction SilentlyContinue | Format-Table Name, Status, StartType -AutoSize
    if (Get-Command sqlcmd -ErrorAction SilentlyContinue) {
        "--- Default instance:"
        sqlcmd -S . -E -l 5 -Q "SET NOCOUNT ON; SELECT @@VERSION; SELECT 'IsIntegratedSecurityOnly=' + CAST(SERVERPROPERTY('IsIntegratedSecurityOnly') AS varchar(5)) + '  (0 = mixed mode)'"
    } else { 'sqlcmd: NOT FOUND' }
    "--- SSMS:"
    Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue |
        Where-Object DisplayName -like '*Management Studio*' | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
}

Save '08-git-7zip.txt' {
    try { git --version } catch { 'git: NOT FOUND' }
    "7-Zip present=" + ((Test-Path "$env:ProgramFiles\7-Zip\7z.exe") -or (Test-Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe"))
    "Telerik licence file present=" + (Test-Path "$env:APPDATA\Telerik\telerik-license.txt") + "   (presence only; contents not read)"
}

# One combined file for pasting into chat
$all = Join-Path $out 'ALL.txt'
Get-ChildItem $out -Filter '0*.txt' | Sort-Object Name | ForEach-Object {
    "===== $($_.Name) ====="
    Get-Content $_.FullName
    ''
} | Out-File $all -Encoding utf8

Write-Host ""
Write-Host "Done. Open $all, copy everything, paste it into the chat."
Start-Process notepad.exe $all
