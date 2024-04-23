#!/usr/bin/env bash

# 获取当前脚本路径
shell_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 是否需要初始化安装
need_install=0

# 判断git是否安装
if ! which git > /dev/null 2>&1; then
    need_install=1
fi

# 判断python是否安装
if which python > /dev/null 2>&1; then
    python="python"
elif which python3 > /dev/null 2>&1; then
    python="python3"
else
    need_install=1 
fi

if [ $need_install == 1 ]; then
    echo "install toolchain"
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get -qq install git \
        python3 python3-pip python3-venv \
        gcc  gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch libncurses5-dev\
        qemu qemu-system-arm \
        -y
fi

# 克隆rtt-packages
if [ ! -d "manifests/packages/.git" ]; then
    git clone https://github.com/rt-thread/packages.git "$shell_dir/manifests/packages"
fi

# 克隆rtt-toolchain
if [ ! -d "manifests/toolchain/.git" ]; then
    git  clone https://github.com/rt-thread/sdk.git "$shell_dir/manifests/toolchain"
fi

# 创建python venv环境
venv_path="$shell_dir/.venv"
if [ ! -d "$venv_path" ]; then
    echo "create rt-thread venv in $venv_path"
    if which python > /dev/null 2>&1; then
        python -m venv "$venv_path"
    else
        python3 -m venv "$venv_path"
    fi
    source "$venv_path/bin/activate"
    pip install "$shell_dir/scripts"
else
    echo "activate rt-thread venv in $venv_path"
    source "$venv_path/bin/activate"
fi


export ENV_ROOT="$shell_dir"
export PKGS_ROOT="$shell_dir/manifests"
export PKGS_DIR="$shell_dirmanifests"
export PATH=~/.env/tools/scripts:$PATH


echo "`git --version` in `which git`"
echo "`python --version` in `which python3`"
echo "`scons --version`"
