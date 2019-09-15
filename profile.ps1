function Get-LatestCommit {
    $DidMatch = (git log -n 1) -join ' ' -match '(?s)commit (?<commithash>[\w0-9]+)'
    if ($DidMatch) {
        $Matches.commithash.SubString(0, 6)
    }
}


function prompt {
    $CurrentPosition = $Host.UI.RawUI.CursorPosition
    $Buffer = $Host.UI.RawUI.BufferSize

    $Content = (Get-Date).ToString()
    $Host.UI.RawUI.CursorPosition = [System.Management.Automation.Host.Coordinates]::new($Buffer.Width - $Content.Length -2, $CurrentPosition.Y)
    Write-Host -NoNewline -Object "$([char]27)[38;2;0;200;255m $Content"
    $Host.UI.RawUI.CursorPosition = $CurrentPosition

    if ((git log -n 1 *>&1) -join ' ' -notmatch 'fatal') {
        "$([char]27)[38;2;233;78;50m$([char]27)[39;49m" +' {1}:{0} > ' -f (Get-LatestCommit), ((git branch) -replace '\* ')

    }
    else {
        ' Christopher Glover > '
    }
}

$env:PATH += '/usr/local/bin'