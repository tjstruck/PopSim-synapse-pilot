sudo yum install docker
sudo service docker start
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
