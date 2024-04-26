#!/usr/bin/env bash

# 获取当前脚本路径
shell_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# 是否需要初始化安装
need_install = 0

# 判断git是否安装
if ! which git > /dev/null 2>&1; then
    echo "not found git"
    need_install = 1
fi

# 判断python是否安装
if ! which python > /dev/null 2>&1; then
    echo "not found python"
    need_install = 1 
fi

if [ need_install == 1 ]; then
    echo "install toolchain"
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get -qq install git \
        python3 python3-pip \
        gcc  gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch libncurses5-dev\
        qemu qemu-system-arm \
        -y
fi

# 克隆rtt-packages
if [ ! -d "manifests/packages/.git" ]; then
    git clone https://github.com/rt-thread/packages.git "$shell_dir/manifests/packages"
fi

# 克隆rtt-toolchain
if [ ! -d "manifests/toolchain/git" ]; then
    git  clone https://github.com/rt-thread/sdk.git "$shell_dir/manifests/toolchain"
fi

# 创建python venv环境
if [ ! -d "$shell_dir/.venv" ]; then
    python -m venv "$shell_dir/.venv"
    pip install "$shell_dir/scripts"
fi

source "$shell_dir/.venv/Scripts/Activate.sh"

export ENV_ROOT="$shell_dir"
export PKGS_ROOT="$shell_dir/manifests"
export PKGS_DIR="$shell_dirmanifests"

export PATH=~/.env/tools/scripts:$PATH
