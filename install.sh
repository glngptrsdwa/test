#!/bin/bash
echo "================================================================="
echo -e "\033[0;35m"
echo "███████╗████████╗██████╗ ███████╗███████╗███████╗     ██████╗ █████╗ ██████╗ ██╗████████╗ █████╗ ██╗  ";
echo "██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝    ██╔════╝██╔══██╗██╔══██╗██║╚══██╔══╝██╔══██╗██║  ";
echo "███████╗   ██║   ██████╔╝█████╗  ███████╗███████╗    ██║     ███████║██████╔╝██║   ██║   ███████║██║  ";
echo "╚════██║   ██║   ██╔══██╗██╔══╝  ╚════██║╚════██║    ██║     ██╔══██║██╔═══╝ ██║   ██║   ██╔══██║██║  ";
echo "███████║   ██║   ██║  ██║███████╗███████║███████║    ╚██████╗██║  ██║██║     ██║   ██║   ██║  ██║███████╗  ";
echo "╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝     ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝  ";
echo -e "\e[0m"
echo "================================================================="


sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
QUICKSILVER_PORT=11
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export QUICKSILVER_CHAIN_ID=killerqueen-1" >> $HOME/.bash_profile
echo "export QUICKSILVER_PORT=${QUICKSILVER_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$QUICKSILVER_CHAIN_ID\e[0m"
echo -e "Your port: \e[1m\e[32m$QUICKSILVER_PORT\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y

# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
rm quicksilver -rf
git clone https://github.com/ingenuity-build/quicksilver.git --branch v0.4.1
cd quicksilver
make build
sudo chmod +x ./build/quicksilverd && sudo mv ./build/quicksilverd /usr/local/bin/quicksilverd

# config
quicksilverd config chain-id $QUICKSILVER_CHAIN_ID
quicksilverd config keyring-backend test
quicksilverd config node tcp://localhost:${QUICKSILVER_PORT}657

# init
quicksilverd init $NODENAME --chain-id $QUICKSILVER_CHAIN_ID

# download genesis and addrbook
wget -qO $HOME/.quicksilverd/config/genesis.json "https://raw.githubusercontent.com/ingenuity-build/testnets/main/killerqueen/genesis.json"

# set peers and seeds
SEEDS="dd3460ec11f78b4a7c4336f22a356fe00805ab64@seed.killerqueen-1.quicksilver.zone:26656"
PEERS="bc7340eaf80eb5af1bdbd3e340130dc3a0acc5c4@65.108.203.149:46656,8859f032ea73ace68ca1124a09cbb462ce775a8b@38.242.131.222:26656,88b32e19974a6d1d6dd10341bc8e2ac3940d7ebc@65.108.255.218:11656,21e11937b8f3edb0917ecdba68a0b29452868b80@65.21.138.123:31656,82475f7ddf1f00325e90be4eabef3f41700adb42@31.111.24.80:26656,d1fe2ef9a5418f53a26e5cd7066795e872873557@149.102.137.5:26656,66c9fd4e4ca5b2255b4d135a81edef32f3346dc2@5.161.78.112:44656,059bbdc40a23f3d31ed758ebb303e0dc1230d31d@34.66.244.130:26656,f0104cc0de9b372b1e59be7903fa3d2233da6cba@65.108.254.209:11656,b78a8d08b37b6f230cd664bd97b96ad4c1044394@135.181.73.169:26656,6d44eb77181b960d15f7671f058b5befaa04e45e@154.53.37.197:26656,0d99b3398284f2055a1d6c448bf460bf86203e51@65.108.105.48:14656,19ecce5861b059c349d3b26740b4c90e7b407432@194.163.141.20:46656,241833817b8158bbdfb00f0b9dcc98d6b1f904ac@46.4.23.42:26656,97d01a9dcb4d3d9aa7e6a468af6e9709d5608c96@65.21.78.153:22656,b3e959a0e0d9a56e4a14253b8330e0c0e968ac59@23.96.13.59:11656,968a57531b3e6850ed220bdf3278d3d07a15d2ca@188.166.125.32:26656,a37474c1f254cd4b16d924327a755c914e8e7d86@51.75.135.46:27756,46d2eb9953403de555369ab5d144c713a6e5b960@144.76.67.53:2390,70c9f64fb387039652571a2431354841ddc9d7ca@202.61.225.157:26656,fd1b1ef4740ba0d2b1401967e8b9acff35b08606@135.181.116.109:47656,2c60847960033354430e60ded7e4984c65dda741@194.35.120.131:11656,288d55e8717bc3b617fc63a8919ff97d001abcd9@65.108.13.185:27060,c2baebdc5468ef0e86f7850bdd8cd91e20fa53b2@65.108.71.92:48656,fcfcf2402f106b300ada70fce2ff52603290c43a@104.248.112.44:11656,3ef59b5ec4de6df88fa36a4ae4394c880885d59d@20.29.56.217:11656,30d0025985d1e907912a8759cfe21a2213ba6faf@35.224.199.187:26656,3b4cc7ee11c3eb7a8402eb8f505e1e0a00efc047@20.211.125.219:11656,977844c9f9d00269c74cb6ac0fc3b13507efd836@54.36.109.62:36656,32c02237e747126166d54cdd3777d4c4cd89fba6@65.21.134.202:26676,7928befd69d36913f94a9e94b018474823b7a45e@95.216.167.96:11656,b0621d2bd6bbade5fbd9ac7c087e2aef9c78c9b2@95.216.174.133:11656,c8a3c2f87773625b1729ef112038366a63c423ce@161.97.168.60:26656,a258c7417ae099dba984c5b2c0a7d026646bde9c@161.97.137.252:26656,6068d8265ab23a243950625305f03ea26dce8343@157.90.30.84:26656,ae0c5259af3830c7933a89f9c5052c6465a3db62@194.163.164.52:26656,003889f64113bdcf8e07f9b595c3d22e94aa0767@142.132.151.99:15616,dd3460ec11f78b4a7c4336f22a356fe00805ab64@65.108.203.150:26656,a15371091fe0d7e8527dba2afaf3706e2577c93d@34.125.46.4:26656,d5981d276f523d88ab8997d3e61d8f202d87f439@38.242.252.175:28656,60ac1299d5116257e259e73e8536174a8f57ce15@62.141.45.192:44656,f259e8661b1c0404cd53c54598ffb68fe3fae264@65.108.230.161:26656,88aefa87636e1fc8d1c111052cf648ec9bca2d06@138.68.175.97:11656,c73e0f1af31eec4652992b410ca7862622b9ec08@65.108.135.213:26756,bb34b612f5ddf02a7736a10156237dc8069ac1fa@206.189.89.193:26656,25871f7620521f5b90a03d38a3c4a29c6b676eb5@137.184.37.93:11656,13efad5e98f92b7fa1a1a24a1fc3aae1e7c3321f@65.21.143.79:20556,be60294c16a02d926c4f5cdb9d7b74884c074358@149.102.141.17:11656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.quicksilverd/config/config.toml

# set custom ports
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${QUICKSILVER_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${QUICKSILVER_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${QUICKSILVER_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${QUICKSILVER_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${QUICKSILVER_PORT}660\"%" $HOME/.quicksilverd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${QUICKSILVER_PORT}317\"%; s%^address = \":8080\"%address = \":${QUICKSILVER_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${QUICKSILVER_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${QUICKSILVER_PORT}091\"%" $HOME/.quicksilverd/config/app.toml

# config pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="2000"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.quicksilverd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.quicksilverd/config/app.toml

# set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uqck\"/" $HOME/.quicksilverd/config/app.toml

# enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.quicksilverd/config/config.toml

# reset
quicksilverd tendermint unsafe-reset-all --home $HOME/.quicksilverd

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/quicksilverd.service > /dev/null <<EOF
[Unit]
Description=quicksilver
After=network-online.target

[Service]
User=$USER
ExecStart=$(which quicksilverd) --home $HOME/.quicksilverd start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable quicksilverd
sudo systemctl restart quicksilverd

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u quicksilverd -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mcurl -s localhost:${QUICKSILVER_PORT}657/status | jq .result.sync
