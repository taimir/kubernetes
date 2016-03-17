# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# A Dockerfile for creating a Logstash instance that is designed
# to work with Kubernetes logging. Additionally, a Monasca ouput gem
# is attached to the logger.

FROM jruby:1.7-jre

ENV DEBIAN_FRONTEND noninteractive

# Add logstash DEB package
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb http://packages.elastic.co/logstash/2.2/debian stable main" | tee -a /etc/apt/sources.list

# Install logstash and dependencies
RUN apt-get update && \
    apt-get install -y logstash && \
    apt-get install -y git && \
    apt-get clean

# Change the default user and group to root.
# Needed to allow access to /var/log/docker/... files.
RUN sed -i -e "s/USER=logstash/USER=root/" -e "s/GROUP=logstash/GROUP=root/" /etc/init.d/logstash


# Clone the logstash monasca plugin.
RUN git clone https://github.com/FujitsuEnablingSoftwareTechnologyGmbH/logstash-output-monasca_api.git /logstash-output-monasca

# Install the Plugin gem.
RUN cd /logstash-output-monasca && \
    jruby -S gem build logstash-output-monasca_log_api.gemspec

# Add plugin Gem to logstash
RUN echo 'gem "logstash-output-monasca_log_api", :path => "/logstash-output-monasca"' \
    >>  /opt/logstash/Gemfile

# Install the logstash Monasca output plugin.
RUN /opt/logstash/bin/plugin install --no-verify

# Copy the Logstash configuration file.
COPY logstash-monasca.conf /etc/logstash/conf.d

# Startup script.
COPY run.sh /

# Command to be executed to start the container. Arguments are:
# monasca_log_api=$1
# keystone_api=$2
# openstack_project_name=$3
# openstack_username=$4
# openstack_password=$5
# openstack_domain=$6
CMD ["/run.sh"]
