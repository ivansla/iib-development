# remove all containers
sudo docker ps -a -q -f status=exited | xargs sudo docker rm

#remove all images
sudo docker rmi $(sudo docker images -q) -f

python3 -m http.server 9000

ip addr show


sudo docker build --tag mq-base \
--build-arg QM_NAME='QMgr01' \
--build-arg QM_PORT=1414 .


sudo docker run --env LICENSE=accept --env MQ_QMGR_NAME=QM1 --volume /home/ivansla/Tools/MQ/workdir:/MQHA --publish 1414:1414 --publish 1424:1424 --publish 9443:9443 --publish 4414:4414 --publish 5000:5000 --detach --tty --name QM1 mq-base
sudo docker run --env LICENSE=accept --env MQ_QMGR_NAME=QM2 --volume /home/ivansla/Tools/MQ/workdir:/MQHA --publish 1434:1414 --publish 1444:1424 --publish 9453:9443 --publish 4424:4414 --publish 5010:5000 --detach --tty --name QM2 mq-base

sudo docker exec -ti QM1 bash


MQ EXPLORER setup
    su - iibadmin -c "/opt/mqm/samp/bin/amqauthg.sh P31PQ${PSB_ENV}01 ${PSB_LDAP_ADMIN_GROUP}"
    # /opt/mqm/samp/bin/amqauthg.sh does not set the +connect on qmgr
    su - iibadmin -c "setmqaut -m P31PQ${PSB_ENV}01 -t qmgr -g ${PSB_LDAP_MQ_GROUP} +connect"



sudo docker network create my-network
sudo docker network connect my-network QM1
When creating cluster between docker containers, you need to use container names and internal ports in MQExplorer