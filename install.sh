#/usr/bin/bash

cdp=$(cd "$(dirname "$0")"; pwd)
sudo cp $cdp/sth /usr/bin
sudo chmod +x /usr/bin/sth
echo "Install success!Enjoy!"
