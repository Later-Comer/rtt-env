
$tz = Get-TimeZone
if ($tz.BaseUtcOffset.TotalHours -eq 8 `
        -or "$1" -eq "--gitee" `
        -or "$1" -eq "--china") {
    $python_amd64_url = "https://registry.npmmirror.com/-/binary/python/3.12.3/python-3.12.3-amd64.exe"
    $git_for_windows_url = "https://registry.npmmirror.com/-/binary/git-for-windows/v2.44.0.windows.1/MinGit-2.44.0-64-bit.zip"

    $rtt_pkg_url = "https://gitee.com/RT-Thread-Mirror/packages.git"
    $rtt_sdk_url = "https://github.com/RT-Thread-Mirror/sdk.git"
    $rtt_env_url = "https://gitee.com/RT-Thread-Mirror/env.git"
} else {
    $python_amd64_url = "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
    $git_for_windows_url = "https://registry.npmmirror.com/-/binary/git-for-windows/v2.44.0.windows.1/MinGit-2.44.0-64-bit.zip"

    $rtt_pkg_url = "https://github.com/rt-thread/packages.git"
    $rtt_sdk_url = "https://github.com/rt-thread/sdk.git"
    $rtt_env_url = "https://github.com/rt-thread/env.git"
}

function Test-Command([string] $cmd) {
    ($null -ne (Get-Command $cmd -ErrorAction SilentlyContinue))
}

# install python
if (!(Test-Command python)) {
    Write-Host "Python not found, will install python 3.12.3"
    if (-not (Test-Path -Path "python-3.12.3.exe")) {
        Invoke-WebRequest -O python-3.12.3.exe $python_url
    }
    cmd /c python-3.12.3.exe /quiet TargetDir=$PSScriptRoot\toolchain\python\python-3.12.3 AssociateFiles=0 Shortcuts=0 Include_doc=0
    Write-Host "python 3.12.3 install to $PSScriptRoot\toolchain\python\python-3.12.3"
} else {
    Write-Host  $(python --version)  "found in"  $(python -c "import sys; print(sys.executable)")
}

# create or activate venv
$VENV_ROOT = "$PSScriptRoot\.venv"
if (-not (Test-Path -Path $VENV_ROOT)) {
    Write-Host "Create Python venv for RT-Thread..."
    python -m venv $VENV_ROOT
    # activate python venv
    & "$VENV_ROOT\Scripts\Activate.ps1"
    # install env-script
    pip install "git+$rtt_env_url"
} else {
    # activate python venv
    & "$VENV_ROOT\Scripts\Activate.ps1"
}

# clone rtt-pkg
if (-not (Test-Path -Path "$PSScriptRoot\manifests\packages\.git")) {
    git clone "$rtt_pkg_url" "$PSScriptRoot\manifests\packages"
}

# clone rtt-sdk
if (-not (Test-Path -Path "$PSScriptRoot\manifests\sdk\.git")) {
    git clone "$rtt_sdk_url $PSScriptRoot\manifests\sdk"
}

# env相关路径
$env:ENV_ROOT = "$PSScriptRoot"
$env:ENV_SETTING_PATH = "$PSScriptRoot\setting"
$env:ENV_DOWNLOAD_PATH = "$PSScriptRoot\downlaod"
$env:ENV_PROGRAM_PATH = "$PSScriptRoot\program"
$env:ENV_MANIFESTS_PATH = "$PSScriptRoot\manifests"
# pkgs相关路径
$env:PKGS_ROOT = "$PSScriptRoot\manifests"
$env:PKGS_DIR = "$PSScriptRoot\manifests"
# sdk相关路径
$env:SDK_INDEX_ROOT = "$PSScriptRoot\manifests\sdk"

$env:pathext = ".ps1; $env:pathext"
