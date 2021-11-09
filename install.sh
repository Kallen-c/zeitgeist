#!/bin/bash

echo -e "\033[35m"


echo -ne "\033[35m██████╗░░█████╗░  "
echo -e "\033[34m░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░"

echo -ne "\033[35m██╔══██╗██╔══██╗  "
echo -e "\033[34m██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗"

echo -ne "\033[35m██████╔╝██║░░██║  "
echo -e "\033[34m██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║"

echo -ne "\033[35m██╔══██╗██║░░██║  "
echo -e "\033[34m██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║"

echo -ne "\033[35m██║░░██║╚█████╔╝  "
echo -e "\033[34m╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝"

echo -ne "\033[35m╚═╝░░╚═╝░╚════╝░  "
echo -e "\033[34m░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░"

echo -e "\033[35m"
echo -e "\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$"
echo -e "https://t.me/ro_cryptoo"
echo -e "https://t.me/whitelistx1000"
echo -e "\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$"
echo -e ""


if [ ! $NODENAME ]; then
	read -p "Node name: " NODENAME
fi
echo 'Node name: ' $NODENAME
sleep 1
echo 'export NODENAME='$NODENAME >> $HOME/.profile

curl -s https://raw.githubusercontent.com/Kallen-c/utils/main/installers/install_ufw.sh | bash

sudo apt update
sudo apt install make clang pkg-config libssl-dev build-essential git mc jq -y
curl https://getsubstrate.io -sSf | bash -s -- --fast
source $HOME/.cargo/env
sleep 1

git clone https://github.com/zeitgeistpm/zeitgeist.git
cd zeitgeist
git checkout v0.2.0
./scripts/init.sh

mkdir -p $HOME/zeitgeist/target/release/
wget https://github.com/zeitgeistpm/zeitgeist/releases/download/v0.2.0/zeitgeist_parachain -O $HOME/zeitgeist/target/release/zeitgeist
chmod +x $HOME/zeitgeist/target/release/zeitgeist
curl -o $HOME/battery-station-relay.json https://raw.githubusercontent.com/zeitgeistpm/polkadot/battery-station-relay/node/service/res/battery-station-relay.json

sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald

sudo tee <<EOF >/dev/null /etc/systemd/system/zeitgeist.service
[Unit]
Description=Zeitgeist Node
After=network-online.target
[Service]
User=$USER
Nice=0
ExecStart=$HOME/zeitgeist/target/release/zeitgeist \
    --bootnodes=/ip4/45.33.117.205/tcp/30001/p2p/12D3KooWBMSGsvMa2A7A9PA2CptRFg9UFaWmNgcaXRxr1pE1jbe9 \
    --chain=battery_station \
    --name="$NODENAME | RO CRYPTO" \
    --parachain-id=2050 \
    --port=30333 \
    --rpc-port=9933 \
    --ws-port=9944 \
    --rpc-external \
    --ws-external \
    --rpc-cors=all \
    -- \
    --bootnodes=/ip4/45.33.117.205/tcp/31001/p2p/12D3KooWHgbvdWFwNQiUPbqncwPmGCHKE8gUQLbzbCzaVbkJ1crJ \
    --bootnodes=/ip4/45.33.117.205/tcp/31002/p2p/12D3KooWE5KxMrfJLWCpaJmAPLWDm9rS612VcZg2JP6AYgxrGuuE \
    --chain=$HOME/battery-station-relay.json \
    --port=30334 \
    --rpc-port=9934 \
    --ws-port=9945
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable zeitgeist
sudo systemctl restart zeitgeist

. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/miscellaneous/insert_variable.sh) -n zeitgeist_log -v "sudo journalctl -f -n 100 -u zeitgeistd" -a
echo -e 'View logs command is zeitgeist_log'
echo -e "\033[0m"
