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

# The URL to download the MQ installer from in tar.gz format
ARG MQ_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqadv/mqadv_dev924_ubuntu_x86-64.tar.gz
ARG IIB_URL=http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.15-IIB.LINUX64-DEVELOPER.tar.gz
# The MQ packages to install
#ARG MQ_PACKAGES="MQSeriesRuntime-*.rpm MQSeriesServer-*.rpm MQSeriesMsg*.rpm MQSeriesJava*.rpm MQSeriesJRE*.rpm MQSeriesGSKit*.rpm"
ARG MQ_PACKAGES="ibmmq-*"

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
    util-linux \
  # Download and extract the MQ installation files
  && mkdir -p /tmp/mq \
  && cd /tmp/mq \
  && curl -LO $MQ_URL \
  && tar -zxvf ./*.tar.gz \
  # Recommended: Create the mqm user ID with a fixed UID and group, so that the file permissions work between different images
  && groupadd --gid 1000 mqm \
  && useradd --uid 1000 --gid mqm --home-dir /var/mqm mqm \
  && usermod -G mqm root \
  && useradd mqexplorer \
  && adduser mqexplorer mqm \
  && cd /tmp/mq/MQServer \
  # Accept the MQ license
  && ./mqlicense.sh -text_only -accept \
  # Install MQ using the RPM packages
  && apt install ./$MQ_PACKAGES \
  # Recommended: Set the default MQ installation (makes the MQ commands available on the PATH)
  && /opt/mqm/bin/setmqinst -p /opt/mqm -i \
  # Clean up all the downloaded files
  && rm -rf /tmp/mq \
  && rm -rf /var/lib/apt/lists/* \
  # IIB
  && mkdir -p /tmp/iib \
  && cd /tmp/iib \
  && curl -LO $IIB_URL \
  && tar -zxvf ./*.tar.gz \
  && mv $(ls -d */ | head -n 1) /opt/iib \
  && rm -rf /tmp/iib \
  && cd /opt/iib \
  && ./iib make registry global accept license silently \
  && cd /opt/iib/server/bin \
  && echo "alter qmgr chad(enabled)" >> /tmp/init.mqsc \
  && echo "alter qmgr chlauth(disabled)" >> /tmp/init.mqsc

COPY *.sh /usr/local/bin/
COPY *.mqsc /etc/mqm/

RUN chmod +x /usr/local/bin/*.sh

# Always use port 1414 (the Docker administrator can re-map ports at runtime)
EXPOSE 1414

# Always put the MQ data directory in a Docker volume
VOLUME /var/mqm

ENTRYPOINT ["mq.sh"]
