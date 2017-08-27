{% from "nxlog/map.jinja" import nxlog_map with context %}

nxlog:
  pkg.installed:
    - name: {{ nxlog_map.pkg }}
    - sources:
      - {{ nxlog_map.pkg }}: {{ nxlog_map.source }}
  service.running:
    - name: {{ nxlog_map.service }}
    - enable: True
    - require:
      - pkg: nxlog
    - watch:
      - pkg: nxlog
