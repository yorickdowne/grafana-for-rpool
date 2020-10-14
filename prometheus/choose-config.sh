#!/bin/sh
# Avoid needing multiple grafana.yml files by checking CLIENT, which is COMPOSE_FILE, for the
# Prometheus config we need.
# Expects a full prometheus command with parameters as argument(s)

case "$CLIENT" in
  *lighthouse* ) conffile=lh-prom.yml ;;
  *prysm* ) conffile=prysm-prom.yml ;;
  * ) conffile=prometheus.yml ;;
esac

"$@" --config.file=/etc/prometheus/$conffile
