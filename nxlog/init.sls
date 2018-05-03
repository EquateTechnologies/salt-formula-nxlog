{% from "nxlog/map.jinja" import nxlog_settings with context %}

{% if nxlog_settings.lookup.packages != [] %}
nxlog_prereq_packages:
  pkg.installed:
    - pkgs: {{ nxlog_settings.lookup.packages }}
{% endif %}

pkg-nxlog:
  pkg.installed:
    - name: {{ nxlog_settings.lookup.package }}
{% if nxlog_settings.install_from_package_source == True %}
{% if 'package_source' in nxlog_settings.lookup and nxlog_settings.lookup.package_source != '' %}
    - sources:
      - {{ nxlog_settings.lookup.package }}: {{ nxlog_settings.lookup.package_source }}
{% endif %}
{% endif %}
{% if nxlog_settings.lookup.packages != [] %}
    - require:
      - pkg: nxlog_prereq_packages
{% endif %}

cfg-nxlog:
  file.managed:
    - name: {{ nxlog_settings.lookup.locations.config_file }}
    - source: salt://nxlog/files/nxlog.conf
    - template: jinja
    - user: {{ nxlog_settings.lookup.user }}
    - group: {{ nxlog_settings.lookup.group }}
    - mode: 0644
    - require:
      - pkg: pkg-nxlog

svc-nxlog:
  service.running:
    - name: {{ nxlog_settings.lookup.service }}
    - enable: True
    - require:
      - pkg: pkg-nxlog
      - file: cfg-nxlog
    - watch:
      - pkg: pkg-nxlog
      - file: cfg-nxlog

{# EOF #}
