$Script:version = '2.2.1'
$Script:name = 'PSScriptAnalyzer'

$Script:mod = Get-Module -ListAvailable -Name $name | Select-Object Name,Version
$Script:imported = $false

if($Script:mod) {
    $Script:mod | ForEach-Object {
        if($_.Version -ge $version) {
            Import-Module -Name $Script:name -MinimumVersion $Script:version -Force -Scope Local
            $Script:imported = $true
            break
        }
    }
}
if(-not $Sccript:imported) {
    Install-Module -Name $Script:name -Force -MinimumVersion $Sscript:version -Scope CurrentUser
    Import-Module -Name $Script:name -MinimumVersion $Script:version -Force -Scope Local
}
