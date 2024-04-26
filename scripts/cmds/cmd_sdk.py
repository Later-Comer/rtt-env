# -*- coding:utf-8 -*-
#
# File      : cmd_sdk.py
# This file is part of RT-Thread RTOS
# COPYRIGHT (C) 2024, RT-Thread Development Team
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
# 2024-04-04     bernard         the first version

import os
import sys
import json
import platform
from vars import Import, Export

'''RT-Thread environment sdk setting'''


def cmd(args):
    from cmds import cmd_menuconfig
    from cmds.cmd_package import list_packages
    from cmds.cmd_package import get_packages
    from cmds.cmd_package import package_update
    import menuconfig

    # change to sdk root directory
    beforepath = os.getcwd()
    os.chdir(args.env_root)

    # start menuconfig
    sys.argv = ['menuconfig', 'Kconfig']
    menuconfig._main()

    # update package
    os.system("pkgs --update --index-path=%s --install-path=%s" % (args.index_path, args.install_path))

    # restore the old directory
    os.chdir(beforepath)


def add_parser(subparsers):
    parser = subparsers.add_parser(
        'sdk',
        help=__doc__,
        description=__doc__,
    )

    parser.add_argument(
        "--env-root",
        help="env root, %s" % Import("env_root"),
        default=Import("env_root"),
        dest="env_root",
    )

    parser.add_argument(
        "--index-path",
        help="toolchain index path, %s" % os.path.join(Import("env_root"), "manifests", "toolchain"),
        default=os.path.join(Import("env_root"), "manifests", "toolchain"),
        dest="index_path",
    )

    parser.add_argument(
        "--install-path",
        help="toolchain install path, %s" % os.path.join(Import("env_root"), "program"),
        default=os.path.join(Import("env_root"), "program"),
        dest="install_path",
    )

    parser.set_defaults(func=cmd)
