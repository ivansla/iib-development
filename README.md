# remove all containers
sudo docker ps -a -q -f status=exited | xargs sudo docker rm

#remove all images
sudo docker rmi $(sudo docker images -q) -f

python3 -m http.server 9000

ip addr show


sudo docker build --tag mq \
--build-arg MQ_URL=http://192.168.15.12:9000/mqadv_dev925_ubuntu_x86-64.tar.gz \
--build-arg QM_NAME='QMgr01' \
--build-arg QM_PORT=1414 .


sudo docker run --env LICENSE=accept --env MQ_QMGR_NAME=QM1 --volume /home/ivansla/Tools/MQ/workdir:/var/mqmshared --publish 1414:1414 --publish 1424:1424 --publish 9443:9443 --publish 4414:4414 --publish 5000:5000 --detach --tty --name QM1 mq 


sudo docker exec -ti QM1 bash