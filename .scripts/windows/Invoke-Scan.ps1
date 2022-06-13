#!/usr/bin/env pwsh
<#
	.SYNOPSIS
	This script will run Invoke-Scan.ps1 on the repo and report it findings.

    .EXAMPLE
    .scripts\windows\Invoke-Scan.ps1

    .EXAMPLE
    .scripts\windows\Invoke-Scan.ps1 -Severity Error

    .EXAMPLE
    .scripts\windows\Invoke-Scan.ps1 -RepoPath c:\repo\foo -Severity Error
#>
[CmdletBinding()]
param (

    # Repo path
    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $RepoPath = $(git rev-parse --show-toplevel),

    # Severity to check for Error|Warning|Information|Any
    [Parameter(Mandatory = $false, Position = 1)]
    [ValidateSet('Error', 'Warning', 'Information')]
    [String]
    $Severity = 'Error'
)
Write-Host "Executing: Invoke-ScriptAnalyzer -Path $RepoPath -Severity $Severity -Recurse -ReportSummary"
switch ($Severity) {
    Error {
        $response = Invoke-ScriptAnalyzer -Path $RepoPath -Severity $Severity -Recurse -ReportSummary | Where-Object { $_.Severity -eq $Severity }
        break
    }
    Warning {
        $sevCheck = 'Error|Warning'
        $response = Invoke-ScriptAnalyzer -Path $RepoPath -Severity $Severity -Recurse -ReportSummary | Where-Object { $_.Severity -match $sevCheck }
        break
    }
    Information {
        $response = Invoke-ScriptAnalyzer -Path $RepoPath -Severity $Severity -Recurse -ReportSummary
        break
    }
}

if ($response) {
    Write-Host "Error: ScriptAnalyzer found errors." -ForegroundColor Red
    $response | ForEach-Object { Write-Host ("{0}:{1} - {2}" -f $_.ScriptPath, $_.line, $_.message); Write-Host "SuggestedCorrections: $($_.SuggestedCorrections)" }
    exit 1
}
else {
    Write-Host "ScriptAnalyzer found no errors."
    exit 0
}
