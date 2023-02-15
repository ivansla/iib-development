# expanded from deprecated repository: https://hub.docker.com/r/ibmcom/mq/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:20.04
LABEL maintainer="islavka2@gmail.com"
VOLUME /var/iibadmin

# The URL to download the MQ installer from in tar.gz format
ARG MQ_URL=http://192.168.15.5:9000/mqadv_dev925_ubuntu_x86-64.tar.gz
ARG ACE_URL=http://10.0.1.229:9000/12.0.5.0-ACE-LINUX64-DEVELOPER.tar.gz
# The MQ packages to install
ARG MQ_PACKAGES="./ibmmq-jre_9.2.5.0_amd64.deb ./ibmmq-runtime_9.2.5.0_amd64.deb ./ibmmq-gskit_9.2.5.0_amd64.deb ./ibmmq-server_9.2.5.0_amd64.deb ./ibmmq-java_9.2.5.0_amd64.deb ./ibmmq-samples_9.2.5.0_amd64.deb"
ARG QM_PORT=''
ARG QM_NAME=''


RUN export DEBIAN_FRONTEND=noninteractive \
  # Optional: Update the command prompt
  && echo "mq:9.0" > /etc/debian_chroot \
  # Install additional packages required by MQ, this install process and the runtime scripts
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    bash \
    bc \
    coreutils \
    curl \
    debianutils \
    findutils \
    gawk \
    grep \
    libc-bin \
    mount \
    passwd \
    procps \
    rpm \
    sed \
    tar \
    vim \
    telnet \
    iputils-ping \
    util-linux \
  # Setting default shell to bash for new users \
  &&  sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd \
  # Download and extract the MQ installation files \
  && mkdir -p /tmp/mq \
  && cd /tmp/mq \
  && curl -LO $MQ_URL \
  && tar -zxvf ./*.tar.gz \
#   Recommended: Create the mqm user ID with a fixed UID and group, so that the file permissions work between different images
  && groupadd --gid 1000 mqm \
  && useradd --uid 1000 --gid mqm --home-dir /MQHA/userdir/mqm mqm \
  && usermod -G mqm root \
  && groupadd --gid 2000 mqbrkrs \
  && useradd --uid 2000 --groups mqbrkrs,mqm --home-dir /MQHA/userdir/iibadmin iibadmin \
  && useradd --uid 3000 --home-dir /MQHA/userdir/mqexplorer mqexplorer \
  && cd /tmp/mq/MQServer \
#   Accept the MQ license
  && ./mqlicense.sh -text_only -accept \
#   Install MQ using the RPM packages
  && apt install ./$MQ_PACKAGES \
#   Recommended: Set the default MQ installation (makes the MQ commands available on the PATH)
  && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
    && echo "#########################################################################" \
    && echo "                 CONFIGURING MQ" \
    && echo "#########################################################################" \
    && echo "mqm             hard    nofile          10240" >> /etc/security/limits.conf \
    && echo "mqm             soft    nofile          10240" >> /etc/security/limits.conf \
    && echo "mqm             hard    nproc           131072" >> /etc/security/limits.conf \
    && echo "mqm             soft    nproc           131072" >> /etc/security/limits.conf \
    && echo "iibadmin        hard    nofile          10240" >> /etc/security/limits.conf \
    && echo "iibadmin        soft    nofile          10240" >> /etc/security/limits.conf \
    && echo "iibadmin        hard    nproc           131072" >> /etc/security/limits.conf \
    && echo "iibadmin        soft    nproc           131072" >> /etc/security/limits.conf \
    && echo "define channel(SYSTEM.ADMIN.SVRCONN) chltype(svrconn)  like (SYSTEM.AUTO.SVRCONN)" >> /tmp/mq.conf \
      && rm -rf /tmp/mq \
      && rm -rf /var/lib/apt/lists/*
#ENTRYPOINT ["mq.sh"]

COPY setup.sh /var/iibadmin
RUN chmod +x /var/iibadmin/*.sh

CMD ["/bin/bash"]
#ENTRYPOINT ["/MQHA/setup.sh", "QMgr01"]