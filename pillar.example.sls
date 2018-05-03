nxlog:
  lookup:
    pkg: 'nxlog-ce'
    service: 'nxlog'
    pkg_source: 'https://nxlog.co/system/files/products/files/348/nxlog-ce-2.9.1716-1_rhel7.x86_64.rpm'
    pkg_source_hash: 'b79455042b31802fc8a77332995a36cf58244446ba7d4edbff2b046c5d89738e'
    log_file: /var/log/nxlog/nxlog.log
    user: nxlog
    group: nxlog
  install_from_package_source: False
  config:
    global:
      - LogLevel: DEBUG
    sections:
      Extension:
        _syslog:
          - Module: xm_syslog
      Input:
        in1:
          - Module: im_udp
          - Port: 514
          - Exec: 'parse_syslog()'
        in2:
          - Module: im_tcp
          - Port: 514
      Processor:
        buffer:
          - Module: pm_buffer
          - MaxSize: 102400
          - Type: disk
      Output:
        fileout1:
          - Module: om_file
          - File: '"/tmp/logmsg.txt"'
          - Exec: 'if $Message =~ /error/ $SeverityValue = syslog_severity_value("error")'
          - Exec: 'to_syslog_bsd()'
        fileout2:
          - Module: om_file
          - File: '"/tmp/logmsg2.txt"'
      Route:
        1:
          - Path: 'in1 => fileout1'
        tcproute:
          - Path: 'in2 => fileout2'
