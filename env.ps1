

function install(){
    

}


$tz = Get-TimeZone
if ($tz.BaseUtcOffset.TotalHours -eq 8) {
    $python_url = "https://registry.npmmirror.com/-/binary/python/3.12.3/python-3.12.3-amd64.exe"
    $pkg_url = "https://github.com/rt-thread/packages"
    $sdk_url = "https://github.com/rt-thread/sdk"
    $git_url = "https://registry.npmmirror.com/-/binary/git-for-windows/v2.44.0.windows.1/MinGit-2.44.0-64-bit.zip"
} else {
    $python_url = "https://www.python.org/ftp/python/3.12.3/python-3.12.3-amd64.exe"
    $pkg_url = "https://github.com/rt-thread/packages"
    $sdk_url = "https://github.com/rt-thread/sdk"
    $git_url = "https://registry.npmmirror.com/-/binary/git-for-windows/v2.44.0.windows.1/MinGit-2.44.0-64-bit.zip"
}

# settings = {}
if (Test-Path -path "$PSScriptRoot\settings.json") {
    
}


function Test-Command([string] $cmd) {
    ($null -ne (Get-Command $cmd -ErrorAction SilentlyContinue))
}


# # install rtt-pkg
# if (-not (Test-Path -Path "$PSScriptRoot\manifests\packages\.git")) {
#     git clone $pkg_url $PSScriptRoot\manifests\packages
# }

# # install rtt-sdk
# if (-not (Test-Path -Path "$PSScriptRoot\manifests\toolchain\.git")) {
#     git clone $sdk_url $PSScriptRoot\manifests\toolchain
# }


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

# activate rtt venv
$VENV_ROOT = "$PSScriptRoot\.venv"
# rt-env目录是否存在
if (-not (Test-Path -Path $VENV_ROOT)) {
    Write-Host "Create Python venv for RT-Thread..."
    python -m venv $VENV_ROOT
    # 激活python venv
    & "$VENV_ROOT\Scripts\Activate.ps1"
    # 安装env-script
    pip install "$PSScriptRoot\scripts"
} else {
    # 激活python venv
    & "$VENV_ROOT\Scripts\Activate.ps1"
}

$env:ENV_ROOT = "$PSScriptRoot"
$env:PKGS_ROOT = "$PSScriptRoot\manifests"
$env:PKGS_DIR = "$PSScriptRoot\manifests"

$env:pathext = ".ps1; $env:pathext"
