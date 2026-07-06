Param([switch][bool]$system,[switch][bool]$global,[switch][bool]$local)
# --systemでシステム、--globalでユーザー、--localでリポジトリ内を対象として設定を行う。優先順位はlocal>global>system
function SetGitConfig ([ValidateSet('--system','--global','--local')][string]$scope) 
{
    git config $scope merge.tool unityyamlmerge
    git config $scope mergetool.unityyamlmerge.trustExitCode true
    git config $scope mergetool.unityyamlmerge.cmd "powershell \`"&(Get-ItemPropertyValue `'HKCU:\Software\Unity Technologies\Installer\Unity' -Name 'Location x64' | Join-Path -ChildPath 'Editor\Data\Tools\UnityYAMLMerge.exe')  merge -p `$BASE `$REMOTE `$LOCAL `$MERGED\`""
}

# 引数が何も指定されていない場合は、デフォルトで $local を有効にする
if (-not ($system -or $global -or $local)){
    $global = $true
}

if ($system) {
    Write-Output 'Setting up system configuration...' 
    SetGitConfig('--system')
}
if ($global){
    Write-Output 'Setting up global configuration...' 
    SetGitConfig('--global')
}
if ($local){
    Write-Output 'Setting up local configuration...' 
    SetGitConfig('--local')
}

Pause
