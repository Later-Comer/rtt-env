#!/usr/bin/env bash

# 根据--gitee选择服务器
if [ "$1" == "--gitee" ] || [ "$1" == "--china" ]; then
    rtt_pkg_url="https://gitee.com/RT-Thread-Mirror/packages.git"
    rtt_sdk_url="https://github.com/RT-Thread-Mirror/sdk.git"
    rtt_env_url="https://gitee.com/RT-Thread-Mirror/env.git"
else
    rtt_pkg_url="https://github.com/rt-thread/packages.git"
    rtt_sdk_url="https://github.com/rt-thread/sdk.git"
    rtt_env_url="https://github.com/RT-Thread/env.git"
fi

# get script dir
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [ ! -f "$script_dir/install.lock" ]; then
    echo "install toolchain"
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get -qq install git \
        python3 python3-pip python3-venv \
        gcc gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch libncurses5-dev qemu qemu-system-arm \
        -y
fi

# create or activate venv
venv_path="$script_dir/.venv"
if [ ! -d "$venv_path" ]; then
    echo "create rt-thread venv in $venv_path"
    if which python >/dev/null 2>&1; then
        python -m venv "$venv_path"
    else
        python3 -m venv "$venv_path"
    fi
    source "$venv_path/bin/activate"
    pip install "git+$rtt_env_url"
else
    echo "activate rt-thread venv in $venv_path"
    source "$venv_path/bin/activate"
fi

# clone rtt-pkg
pkg_idx_dir="$script_dir/manifests/packages"
if [ ! -d "$pkg_idx_dir/.git" ]; then
    git clone "$rtt_pkg_url" "$pkg_idx_dir"
fi

# clone rtt-sdk
sdk_idx_dir="$script_dir/manifests/sdk"
if [ ! -d "$sdk_idx_dir/.git"]; then
    git clone "$rtt_sdk_url" "$sdk_idx_dir"
fi

# env
export ENV_ROOT="$script_dir"
export ENV_SETTING_PATH="$script_dir/setting"
export ENV_DOWNLOAD_PATH="$script_dir/downlaod"
export ENV_PROGRAM_PATH="$script_dir/program"
export ENV_MANIFESTS_PATH="$script_dir/manifests"
# pkgs
export PKGS_ROOT="$script_dir/manifests"
export PKGS_DIR="$script_dir/manifests"
# sdk
export SDK_INDEX_ROOT="$script_dir/manifests/sdk"

echo "$(git --version) in $(which git)"
echo "$(python --version) in $(which python3)"
echo "$(scons --version)"
