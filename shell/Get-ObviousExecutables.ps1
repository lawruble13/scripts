$UserPrefix="$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
$AllPrefix="C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$Commands = @{}
$FormatEnumerationLimit = -1

function Process-Link{
    param (
        $Link,
        [PSDefaultValue(Help = 'Current Directory')]
        $Prefix = (Get-Location)
    )
    $LinkCommand = ([IO.Path]::GetFileNameWithoutExtension($Link)).ToLower()
    $LinkRun = "$Prefix\$Link"

    $Executable = (New-Object -ComObject WScript.Shell).CreateShortcut("$Prefix\$Link")
    $ExecutableValid = ($Executable.TargetPath.Length -gt 0)
    if ($ExecutableValid){
        $ExecCommand = [IO.Path]::GetFileNameWithoutExtension($Executable.TargetPath).ToLower()
        $ExecRun = $Executable.TargetPath
    }

    if ($script:Commands.ContainsKey($LinkCommand)){
        if ($script:Commands[$LinkCommand] -notcontains $LinkRun){
            $script:Commands[$LinkCommand] += $LinkRun
        }
        if ($ExecutableValid -and ($script:Commands[$LinkCommand] -notcontains $ExecRun)){
            $script:Commands[$LinkCommand] += $ExecRun
        }
    } else {
        if ($ExecutableValid){
            $script:Commands[$LinkCommand] = $LinkRun, $ExecRun
        } else {
            $script:Commands[$LinkCommand] = ,$LinkRun
        }
    }

    if ($ExecutableValid -and ($ExecCommand -ne $LinkCommand)) {
        if ($script:Commands.ContainsKey($ExecCommand)){
            if ($script:Commands[$ExecCommand] -notcontains $LinkRun){
                $script:Commands[$ExecCommand] += $LinkRun
            }
            if ($script:Commands[$ExecCommand] -notcontains $ExecRun){
                $script:Commands[$ExecCommand] += $ExecRun
            }
        } else {
            $script:Commands[$ExecCommand] = $LinkRun, $ExecRun
        }
    }
}

function Process-LinkFolder {
    param (
        $Folder,
        $MaxDepth=0
    )
    if ($MaxDepth -ge 0) {
        $Items = Get-ChildItem -Path $Folder -Depth $MaxDepth -Filter *.lnk -ErrorAction SilentlyContinue
    } else {
        $Items = Get-ChildItem -Path $Folder -Recurse -Filter *.lnk -ErrorAction SilentlyContinue
    }
    foreach ($Item in $Items){
        Process-Link -Link $Item -Prefix (Convert-Path $Item.PSParentPath)
    }
}

function Process-Executable {
    param (
        $Exec,
        $Prefix=(Get-Location)
        )
    $ExecCommand = [IO.Path]::GetFileNameWithoutExtension($Exec).ToLower()
    $ExecRun = "$Prefix\$Exec"
    if ($script:Commands.ContainsKey($ExecCommand)){
        if ($script:Commands[$ExecCommand] -notcontains $ExecRun){
            $script:Commands[$ExecCommand] += $ExecRun
        }
    } else {
        $script:Commands[$ExecCommand] = ,$ExecRun
    }
}

function Process-ExecutableFolder {
    param (
        $Folder,
        $MaxDepth=0
    )
    if ($MaxDepth -ge 0) {
        $Items = Get-ChildItem -Path $Folder -Depth $MaxDepth -Filter *.exe -ErrorAction SilentlyContinue
    } else {
        $Items = Get-ChildItem -Path $Folder -Recurse -Filter *.exe -ErrorAction SilentlyContinue
    }
    foreach ($Item in $Items){
        Process-Executable -Exec $item -Prefix (Convert-Path $Item.PSParentPath)
    }

}

Process-LinkFolder -Folder $UserPrefix -MaxDepth 2
Process-LinkFolder -Folder $AllPrefix -MaxDepth 2

Process-ExecutableFolder 'C:\Program Files' -MaxDepth 2
Process-ExecutableFolder 'C:\Program Files (x86)' -MaxDepth 2

$Commands | Format-Table -HideTableHeaders -AutoSize
