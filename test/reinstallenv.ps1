
& ".venv\Scripts\Activate.ps1"
rm -r .\scripts\env.egg-info
rm -r .\scripts\build
pip uninstall env -y
pip install .\scripts
