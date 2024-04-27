import argparse
import json
import os
import sys
import shutil
import time


def git_clone_or_pull(dir, url):
    if not os.path.isdir(os.path.join(dir, ".git")):
        print("clone %s into %s" % (url, dir))
        if os.path.isdir(dir):
            shutil.rmtree(dir)
        os.system("git clone --depth=1  %s  %s" % (url, dir))
    else:
        print("pull %s into %s" % (url, dir))
        beforepath = os.getcwd()
        os.chdir(dir)
        os.system("git remote set-url origin %s" % url)
        os.system("git pull")
        os.chdir(beforepath)


def get_default_prefix():
    return os.path.join(os.environ["HOME"], ".env")


def main():

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--gitee",
        "--china",
        help="using china mirror url",
        action="store_true",
        default=False,
        dest="gitee",
    )

    parser.add_argument(
        "--prefix",
        help="where env installed, %s" % get_default_prefix(),
        default=get_default_prefix(),
        type=str,
        dest="prefix",
    )

    args = parser.parse_args()

    for dir in ["manifests", "download", "program"]:
        os.makedirs(os.path.join(args.prefix, dir), exist_ok=True)

    if args.gitee or time.timezone == -28800:
        pkg_idx_url = "https://gitee.com/RT-Thread-Mirror/packages.git"
        sdk_idx_url = "https://github.com/RT-Thread-Mirror/sdk.git"
        rtt_env_url = "https://gitee.com/RT-Thread-Mirror/env.git"
    else:
        pkg_idx_url = "https://github.com/rt-thread/packages.git"
        sdk_idx_url = "https://github.com/rt-thread/sdk.git"
        rtt_env_url = "https://github.com/RT-Thread/env.git"

    pkg_idx_dir = os.path.join(args.prefix, "manifests", "packages")
    sdk_idx_dir = os.path.join(args.prefix, "manifests", "toolchain")

    git_clone_or_pull(pkg_idx_dir, pkg_idx_url)
    # git_clone_or_pull(sdk_idx_dir, sdk_idx_url)

    with open(os.path.join(args.prefix, "manifests/Kconfig"), "w") as f:
        f.write("$PKGS_DIR/packages/Kconfig\n")


if __name__ == "__main__":
    main()
