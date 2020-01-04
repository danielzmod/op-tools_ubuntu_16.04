# op-tools_ubuntu16.04
Install script for openpilot-tools for Ubuntu 16.04.
Makes it easier to get up and going with openpilot-tools.

Current version builds for v0.7.
If you want an older version v0.6.6 is available (check tags for available versions).
do a git checkout v0.6.6 to check out that install script.

During installation watch out for erros.

```bash
git clone https://github.com/danielzmod/op-tools_ubuntu_16.04.git op_tools_installer
cd op_tools_installercd
./0_install_pyenv.sh
```

```bash
./1_install_op-tools_ubuntu16.04.sh
```
After running this **follow the instructions** on screen you need to do some manual steps aswell.


When rebooting or starting a new terminal dont forget to activate the virtual environment by doing 
```bash
cd openpilot
pipenv shell # Activate virtual environment
```
