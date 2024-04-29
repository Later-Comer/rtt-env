# -*- coding:utf-8 -*-
#
# File      : cmd_package.py
# This file is part of RT-Thread RTOS
# COPYRIGHT (C) 2006 - 2020, RT-Thread Development Team
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
# 2018-05-28     SummerGift      Add copyright information
# 2018-12-28     Ernest Chen     Add package information and enjoy package maker
# 2019-01-07     SummerGift      The prompt supports utf-8 encoding
# 2020-04-08     SummerGift      Optimize program structure
#

import os
from vars import Import, Export
from .cmd_package_printenv import package_print_env, package_print_help
from .cmd_package_list import list_packages, get_packages
from .cmd_package_wizard import package_wizard
from .cmd_package_update import package_update
from .cmd_package_upgrade import package_update_index


def run_env_cmd(args):
    """Run packages command."""

    if args.package_update_force:
        package_update(args)
    elif args.package_update:
        package_update(args)
    elif args.package_create:
        package_wizard()
    elif args.list_packages:
        list_packages(args.package_index_path, args.package_install_info)
    elif args.package_update_index:
        package_update_index(args)
    elif args.package_update_index_force:
        package_update_index(args)
    elif args.package_print_env:
        package_print_env()
    else:
        package_print_help()


def add_parser(subparsers):
    """The packages command parser for env."""

    parser = subparsers.add_parser(
        "pkg",
        aliases=["pkgs", "package"],
        help=__doc__,
        description=__doc__,
    )

    parser.add_argument(
        "--update",
        help="update packages, install or remove the packages by your settings in menuconfig",
        action="store_true",
        default=False,
        dest="package_update",
    )

    parser.add_argument(
        "--update-force",
        "--force-update",
        help="forcely update and clean packages, install or remove packages by settings in menuconfig",
        action="store_true",
        default=False,
        dest="package_update_force",
    )

    parser.add_argument(
        "--list",
        help="list installed packages",
        action="store_true",
        default=False,
        dest="list_packages",
    )

    parser.add_argument(
        "--wizard",
        help="create a new package with wizard",
        action="store_true",
        default=False,
        dest="package_create",
    )

    parser.add_argument(
        "--upgrade",
        "--update-index",
        help="upgrade local packages index from git repository",
        action="store_true",
        default=False,
        dest="package_update_index",
    )

    parser.add_argument(
        "--upgrade-force",
        "--force-upgrade",
        "--update-index-force",
        "--force-update-index",
        help="forcely upgrade local packages index from git repository",
        action="store_true",
        default=False,
        dest="package_update_index_force",
    )

    parser.add_argument(
        "--printenv",
        "--print-env",
        help="print environmental variables to check",
        action="store_true",
        default=False,
        dest="package_print_env",
    )

    parser.add_argument(
        "--index-path",
        help="packages index path, %s" % Import("pkgs_root"),
        type=str,
        default=Import("pkgs_root"),
        dest="package_index_path",
        metavar="PKG_INDEX_PATH",
    )

    parser.add_argument(
        "--install-path",
        help="packages instll path, %s" % os.path.join(os.getcwd(), "packages"),
        type=str,
        default=os.path.join(os.getcwd(), "packages"),
        dest="package_install_path",
        metavar="PKG_INSTALL_PATH",
    )

    parser.add_argument(
        "--install-info",
        help="packages install info which created by menuconfig, %s" % os.path.join(os.getcwd(), ".config"),
        type=str,
        default=os.path.join(os.getcwd(), ".config"),
        dest="package_install_info",
        metavar="PKG_INSTALL_INFO",
    )

    parser.add_argument(
        "--download-path",
        help="packages download path, %s" % os.path.join(Import("env_root"), "local_pkgs"),
        type=str,
        default=os.path.join(Import("env_root"), "local_pkgs"),
        dest="package_download_path",
        metavar="PKG_DOWNLOAD_PATH",
    )

    parser.add_argument(
        "--env-config-file",
        help="env config file, %s" % os.path.join(Import("env_root"), ".config"),
        type=str,
        default=os.path.join(Import("env_root"), ".config"),
        dest="env_config_file",
        metavar="ENV_CONFIG_FILE",
    )

    parser.set_defaults(func=run_env_cmd)
