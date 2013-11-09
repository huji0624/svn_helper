#/usr/bin/bash

cdp=$(cd "$(dirname "$0")"; pwd)
sudo cp $cdp/svh /usr/bin
sudo chmod +x /usr/bin/svh
echo "Install success!Enjoy!"
