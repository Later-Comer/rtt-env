source ".venv/bin/activate"
rm -rf ./scripts/env.egg-info
rm -rf ./scripts/build
pip uninstall env -y
pip install ./scripts
