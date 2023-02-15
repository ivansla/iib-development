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
ARG ACE_URL=http://192.168.15.5:9000/12.0.5.0-ACE-LINUX64-DEVELOPER.tar.gz
# The MQ packages to install
ARG QM_PORT=''
ARG QM_NAME=''


RUN export DEBIAN_FRONTEND=noninteractive \
  && su - iibadmin -c "mkdir -p /tmp/ace;cd /tmp/ace;curl -LO $ACE_URL;tar -zxvf ./*.tar.gz" \
  && cd /tmp/ace \
  && mv $(ls -d */) /opt/ace \
  && rm -rf /tmp/ace

#ENTRYPOINT ["mq.sh"]
CMD ["/bin/bash"]
#ENTRYPOINT ["/MQHA/setup.sh", "QMgr01"]