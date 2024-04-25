# -*- coding:utf-8 -*-
#
# File      : cmd_system.py
# This file is part of RT-Thread RTOS
# COPYRIGHT (C) 2006 - 2018, RT-Thread Development Team
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Change Logs:
# Date           Author          Notes
# 2018-5-28      SummerGift      Add copyright information
#

import os
import sys
from vars import Import

"""RT-Thread environment package system"""


def update_python_modules():
    try:
        from subprocess import call

        call("python -m pip install --upgrade pip", shell=True)

        import pip
        from pip._internal.utils.misc import get_installed_distributions

        for dist in get_installed_distributions():
            call("python -m pip install --upgrade " + dist.project_name, shell=True)
    except:
        print("Fail to upgrade python modules!")


def config_system_setting():
    import menuconfig

    # change to sdk root directory
    beforepath = os.getcwd()
    os.chdir(Import("env_root"))

    # start menuconfig
    sys.argv = ["menuconfig", "Kconfig"]
    menuconfig._main()

    # update package
    toolchain_index_path = os.path.join(Import("env_root"), "manifests", "toolchain")
    toolchain_install_path = os.path.join(Import("env_root"), "program")
    os.system("pkgs --update --index-path=%s --install-path=%s" % (toolchain_index_path, toolchain_install_path))

    # restore the old directory
    os.chdir(beforepath)


def update_env_script():
    # env_root = Import("env_root")

    # if need_using_mirror_download(args):
    #     get_package_url, get_ver_sha = get_url_from_mirror_server("env", "latest")

    #     if get_package_url is not None:
    #         env_scripts_repo = get_package_url
    #     else:
    #         print("Failed to get url from mirror server. Using default url.")
    #         env_scripts_repo = "https://gitee.com/RT-Thread-Mirror/env.git"
    # else:
    #     env_scripts_repo = "https://github.com/RT-Thread/env.git"

    # env_scripts_root = os.path.join(env_root, "tools", "scripts")
    # if force_upgrade:
    #     cwd = os.getcwd()
    #     os.chdir(env_scripts_root)
    #     os.system("git fetch --all")
    #     os.system("git reset --hard origin/master")
    #     os.chdir(cwd)
    # print("Begin to upgrade env scripts.")
    # git_pull_repo(env_scripts_root, env_scripts_repo)
    # print("==============================>  Env scripts upgrade done \n")
    pass


def cmd(args):

    if args.setting:
        config_system_setting()
    elif args.update_python_modules:
        update_python_modules()
    elif args.update_env_script:
        update_env_script()
    else:
        os.system("system -h")


def add_parser(subparsers):
    parser = subparsers.add_parser(
        "sys",
        aliases=["system"],
        help=__doc__,
        description=__doc__,
    )

    parser.add_argument(
        "-s",
        "--setting",
        help="start env setting",
        action="store_true",
        default=False,
        dest="setting",
    )

    # parser.add_argument(
    #     "--update-all",
    #     help="update system menuconfig's online package options ",
    #     action="store_true",
    #     default=False,
    #     dest="system_update",
    # )

    parser.add_argument(
        "--update-python",
        help="update python modules, e.g. requests module",
        action="store_true",
        default=False,
        dest="update_python_modules",
    )

    parser.add_argument(
        "--update-env-script",
        help="update env script",
        action="store_true",
        default=False,
        dest="update_env_script",
    )

    parser.add_argument(
        "--update-packages-index",
        help="update packages index",
        action="store_true",
        default=False,
        dest="update_pkg_index",
    )

    parser.add_argument(
        "--update-toolchain-index",
        help="update toolchain index",
        action="store_true",
        default=False,
        dest="update_sdk_index",
    )

    parser.set_defaults(func=cmd)
