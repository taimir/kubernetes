{% if grains['roles'][0] != 'kubernetes-master' -%}
/etc/kubernetes/manifests/logstash-monasca.yaml:
  file.managed:
    - source: salt://logstash-monasca/logstash-monasca.yaml
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - dir_mode: 755
{% endif %}
