#!/bin/bash
export monasca_log_api=$1
export keystone_api=$2
export openstack_project_name=$3
export openstack_username=$4
export openstack_password=$5
export openstack_domain=$6

configure_and_start() {
  cat <<EOF >>/etc/logstash/conf.d/logstash-monasca.conf

output {
  monasca_log_api {
    monasca_log_api => "${monasca_log_api}"
    keystone_api => "${keystone_api}"
    project_name => "${openstack_project_name}"
    username => "${openstack_username}"
    password => "${openstack_password}"
    domain_id => "${openstack_domain}"
    dimensions => "service: kubernetes"
    application_type_key => "monasca"
  }
  stdout {
    codec => "json"
  }
}
EOF

  echo "Logstash configuration: "
  cat /etc/logstash/conf.d/logstash-monasca.conf

  # check logstash configuration
  /opt/logstash/bin/logstash -f /etc/logstash/conf.d --configtest

  # start logstash
  /opt/logstash/bin/logstash -f /etc/logstash/conf.d --verbose
}

configure_and_start
