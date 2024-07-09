from setuptools import setup, find_packages

setup(
    name='rtenv',
    version='0.0.2',
    description='RT-Thread Env',
    url='https://github.com/RT-Thread/env.git',
    author='RT-Thread Development Team',
    author_email='rt-thread@rt-thread.org',
    keywords='rt-thread',
    license='Apache License 2.0',
    project_urls={
        'Github repository': 'https:/github.com/rt-thread/env.git',
        'User guide': 'https:/github.com/rt-thread/env.git',
    },
    python_requires='>=3.6',
    install_requires=[
        'SCons>=4.0.0',
        'requests',
        'psutil',
        'tqdm',
        'kconfiglib',
        'windows-curses; platform_system=="Windows"',
    ],
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    # package_data={'': ['*.*']},
    # exclude_package_data={'': ['MANIFEST.in']},
    # include_package_data=True,
    entry_points={
        'console_scripts': [
            'rt-env=rtenv.env:main',
            'menuconfig=rtenv.env:menuconfig',
            'pkgs=rtenv.env:pkgs',
            'sdk=rtenv.env:sdk',
            'system=rtenv.env:system',
        ]
    },
)
