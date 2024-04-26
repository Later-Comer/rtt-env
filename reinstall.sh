source ".venv/bin/activate"
rm -r .\scripts\env.egg-info
rm -r .\scripts\build
pip uninstall env -y
pip install .\scripts
