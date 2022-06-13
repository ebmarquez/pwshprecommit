$content = @'
#!/usr/bin/env bash

# testing the pre-commit hook: git hook run pre-commit
REPO=$(git rev-parse --show-toplevel)
SCRIPT="$REPO/.scripts/windows/runPSScriptAnalyzer.ps1"
if [ -f $SCRIPT ]
then
    INVOKECMD="'$SCRIPT' -RepoPath '$REPO' -Severity 'Error'"
    echo "Step pre-commit: $INVOKECMD"
    pwsh -NoExit -NoProfile -NonInteractive -Command "& $INVOKECMD"
fi
'@

$root = $(git rev-parse --show-toplevel)
$hookPath = Join-Path -Path $root -ChildPath '.git/hooks/pre-commit'

if (-not (Test-Path -Path $hookPath)) {

    # Copy performed to maintain the script execute script settings.
    Copy-Item -Path "${hookPath}.sample" -Destination $hookPath -Force
    Write-Verbose -Message "Creating pre-commit hook script at ${hookPath}"
    New-Item -Path $hookPath -ItemType file -Value $content -Force
}
