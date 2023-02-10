#!/bin/bash

QM_NAME_01=
QM_PORT_01=
QM_NAME_02=
QM_PORT_02=

install() {
su - mqm -c "mkdir -p /MQHA/qmgrs/data"
su - mqm -c "mkdir -p /MQHA/qmgrs/log"
chown -R mqm:mqm /MQHA
echo "#########################################################################"
echo "                 CREATE ${QM_NAME_01}"
echo "#########################################################################" 
su - mqm -c "crtmqm -p ${QM_PORT_01} -u SYSTEM.DEAD.LETTER.QUEUE -md /MQHA/qmgrs/data -ld /MQHA/qmgrs/log ${QM_NAME_01}"
su - mqm -c "strmqm ${QM_NAME_01}"
su - mqm -c "setmqaut -m ${QM_NAME_01} -t qmgr -p mqexplorer +connect +inq +dsp"
su - mqm -c "setmqaut -m ${QM_NAME_01} -n SYSTEM.MQEXPLORER.REPLY.MODEL -t queue -p mqexplorer +inq +dsp +get +put"
su - mqm -c "setmqaut -m ${QM_NAME_01} -n SYSTEM.ADMIN.COMMAND.QUEUE -t queue -p mqexplorer +inq +put"
echo "#########################################################################"
echo "                 CREATE ${QM_NAME_02}"
echo "#########################################################################" 
su - mqm -c "crtmqm -p ${QM_PORT_02} -u SYSTEM.DEAD.LETTER.QUEUE -md /MQHA/qmgrs/data -ld /MQHA/qmgrs/log ${QM_NAME_02}"
su - mqm -c "strmqm ${QM_NAME_02}"
su - mqm -c "setmqaut -m ${QM_NAME_02} -t qmgr -p mqexplorer +connect +inq +dsp"
su - mqm -c "setmqaut -m ${QM_NAME_02} -n SYSTEM.MQEXPLORER.REPLY.MODEL -t queue -p mqexplorer +inq +dsp +get +put"
su - mqm -c "setmqaut -m ${QM_NAME_02} -n SYSTEM.ADMIN.COMMAND.QUEUE -t queue -p mqexplorer +inq +put"
su - mqm -c "runmqsc ${QM_NAME_01} < /tmp/mq.conf"
su - mqm -c "runmqsc ${QM_NAME_02} < /tmp/mq.conf"

dspmqinf -o command QMgr01
dspmqinf -o command QMgr02
}

existsQmgr() {
  local qmgrName=$1

  local dspmqResult="$(dspmq | grep ${qmgrName})"

  if [[ "$dspmqResult" == *"${qmgrName}"* ]]
  then
    echo "Queue Manager: ${qmgrName} has been installed."
    return 0
  fi
  return 1
}

setup() {
  QM_NAME_01=$1
  QM_PORT_01=$2
  QM_NAME_02=$3
  QM_PORT_02=$4

  if existsQmgr ${qmgrName}
  then
    echo "No setup required"
  else
    echo "Queue manager: ${qmgrName}, not installed. Installing now..."
    install
  fi
}

setup $1 $2 $3 $4