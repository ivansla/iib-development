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

FROM mq-base:latest
LABEL maintainer="islavka2@gmail.com"

# The URL to download the MQ installer from in tar.gz format
ARG MQ_URL=http://10.0.1.229:9000/mqadv_dev925_ubuntu_x86-64.tar.gz
ARG ACE_URL=http://10.0.1.229:9000/12.0.5.0-ACE-LINUX64-DEVELOPER.tar.gz
# The MQ packages to install
ARG MQ_PACKAGES="./ibmmq-jre_9.2.5.0_amd64.deb ./ibmmq-runtime_9.2.5.0_amd64.deb ./ibmmq-gskit_9.2.5.0_amd64.deb ./ibmmq-server_9.2.5.0_amd64.deb ./ibmmq-java_9.2.5.0_amd64.deb ./ibmmq-samples_9.2.5.0_amd64.deb"
ARG QM_PORT=''
ARG QM_NAME=''


RUN export DEBIAN_FRONTEND=noninteractive \
  && su - iibadmin -c "mkdir -p /tmp/ace;cd /tmp/ace;curl -LO $ACE_URL;tar -zxvf ./*.tar.gz" \
  && cd /tmp/ace \
  && mv $(ls -d */) /opt/ace \
#  && su - mqm -c "curl -LO $ACE_URL" \
#  && su - mqm -c "tar -zxvf ./*.tar.gz"
#  && su - mqm -c "cd /tmp/ace/$(ls /tmp/ace)" \
#  && su - mqm -c "ls" \
#    && su - mqm -c "mv $(ls /tmp/ace) /opt/ace"
  && rm -rf /tmp/ace
#    && cd /opt/ace
#  && /bin/bash -c ". /opt/ace/server/bin/mqsiprofile"









#  && echo "alter qmgr chad(enabled)" >> /tmp/init.mqsc \
#  && echo "alter qmgr chlauth(disabled)" >> /tmp/init.mqsc
#
#COPY ../mq/setup.sh /var/iibadmin/
#COPY 12.0.5.0-ACE-LINUX64-DEVELOPER.tar.gz /var/iibadmin/
#COPY *.mqsc /etc/mqm/

#RUN chmod +x /usr/local/bin/*.sh

# Always use port 1414 (the Docker administrator can re-map ports at runtime)
#EXPOSE 1414

# Always put the MQ data directory in a Docker volume
VOLUME /var/mqm /var/iibadmin /var/mqexplorer /home/ivansla/test

#ENTRYPOINT ["mq.sh"]
CMD ["/bin/bash"]
#ENTRYPOINT ["/MQHA/setup.sh", "QMgr01"]