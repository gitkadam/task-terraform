sudo yum install docker git -y 
sudo systemctl start docker
echo "-----installing docker compose-------"
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version

mkdir work 
cd work
git clone https://github.com/asemhostaway/invo.git
cd invo
sudo docker-compose up -d
sudo docker ps -s
