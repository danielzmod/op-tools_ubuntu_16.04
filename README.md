# op-tools_ubuntu_16.04
Install script for openpilot-tools for Ubuntu 16.04.
Makes it easier to get up and going with openpilot-tools.

Current version builds for v0.7.2.
If you want an older version v0.7,v0.6.6 is available (check tags for available versions).
do a git checkout v0.6.6 to check out that install script.

If something fails script will stop executing.
You will see if the installation was succesfull by a text printout by the script.

```bash
git clone https://github.com/danielzmod/op-tools_ubuntu_16.04.git op_tools_installer
cd op_tools_installer
./0_install_pyenv.sh
```

```bash
./1_install_op-tools_ubuntu16.04.sh
```
When the automated part is finished you can try if the tools work with the supplied log file.

To test the installation you can run the supplied test script (try two times if it fails first time).
```bash
./2_test-replay.sh
```

When rebooting or starting a new terminal dont forget to activate the virtual environment by doing 
```bash
cd openpilot
pipenv shell # Activate virtual environment
```
