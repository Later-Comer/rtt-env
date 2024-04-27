#!/usr/bin/env bash

# 命令行参数
install=false
gitee=false
prefix="$HOME/.env"

function usage() {
    docs="Usage: \
\n\tbash $0 [options] \
\nOptions: \
\n\t--install: install env, otherwise start env, optional\
\n\t--prefix=dir: install path, default is ~/.env, optional\
\n\t--gitee, --china: use china mirror server, optional\
\n\t-h, --help: display help, optional\
\nExample: \
\n\t bash $0 --install --prefix=~/.env  --gitee \
\n\t bash $0 --gitee"

    echo -e "$docs" >&2
}

options=$(getopt -o h -l install,prefix:,gitee,china,help -- "$@")
eval set -- "$options"
while true; do
    case "$1" in
    --install)
        shift
        install=true
        ;;
    --gitee | --china)
        shift
        gitee=true
        ;;
    --prefix)
        shift
        prefix=$1
        shift
        ;;
    -h | --help)
        shift
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done

# 根据--gitee选择服务器
if [ $gitee == "true" ]; then
    pkg_idx_url="https://gitee.com/RT-Thread-Mirror/packages.git"
    sdk_idx_url="https://github.com/RT-Thread-Mirror/sdk.git"
    rtt_env_url="https://gitee.com/RT-Thread-Mirror/env.git"
else
    pkg_idx_url="https://github.com/rt-thread/packages.git"
    sdk_idx_url="https://github.com/rt-thread/sdk.git"
    rtt_env_url="https://github.com/RT-Thread/env.git"
fi

# 获取当前脚本路径
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

function git_clone_or_pul() {
    dir=$1
    url=$2
    if [ ! -d "$dir/.git" ]; then
        if [ -d "$dir" ]; then
            rm -rf "$dir"
        fi
        git clone $url $dir
    else
        pushd "$dir"
        git remote set-url origin $url
        git pull --force
        popd
    fi
}

function create_or_active_venv() {
    # 创建python venv环境
    venv_path="$script_dir/.venv"
    if [ ! -d "$venv_path" ]; then
        echo "create rt-thread venv in $venv_path"
        if which python >/dev/null 2>&1; then
            python -m venv "$venv_path"
        else
            python3 -m venv "$venv_path"
        fi
        source "$venv_path/bin/activate"
        pip install "$script_dir/scripts"
    else
        echo "activate rt-thread venv in $venv_path"
        source "$venv_path/bin/activate"
    fi
}

function install_toolchain() {
    echo "install toolchain"
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get -qq install git \
        python3 python3-pip python3-venv \
        gcc gcc-arm-none-eabi binutils-arm-none-eabi gdb-multiarch libncurses5-dev qemu qemu-system-arm \
        -y

}

function check_toolchain() {

    # 判断git是否安装
    if ! which git >/dev/null 2>&1; then
        return 0
    fi

    # 判断python是否安装
    if which python >/dev/null 2>&1; then
        return 0
    elif which python3 >/dev/null 2>&1; then
        return 0
    else
        rturn 1
    fi

    return 0
}

# 检查是否安装工具
if [ $install == "true" ] || [ "$(check_toolchain)" == 1 ]; then
    install_toolchain
fi

# 检查python虚拟环境
create_or_active_venv

# 检查pkg仓库
pkg_idx_dir="$script_dir/manifests/packages"
git_clone_or_pull "$pkg_idx_dir" "$pkg_idx_url"

# 检查sdk仓库
sdk_idx_dir="$script_dir/manifests/toolchain"
git_clone_or_pull "$sdk_idx_dir" "$sdk_idx_url"

# 检查env仓库
rtt_env_dir="$script_dir/scripts"
git_clone_or_pull "$rtt_env_dir" "$rtt_env_url"

# export ENV_ROOT="$script_dir"
# export PKGS_ROOT="$script_dir/manifests"
# export PKGS_DIR="$script_dirmanifests"
# export PATH=~/.env/tools/scripts:$PATH

# echo "`git --version` in `which git`"
# echo "`python --version` in `which python3`"
# echo "`scons --version`"
