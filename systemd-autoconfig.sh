#!/usr/bin/env sh

sudo cp prometheus.yml /etc/prometheus/
sudo chown root:prometheus /etc/prometheus/prometheus.yml
sudo chmod 640 /etc/prometheus/prometheus.yml
sudo systemctl stop prometheus
sudo systemctl start prometheus

sudo cp grafana.ini /etc/
sudo chown grafana:grafana /etc/grafana.ini
sudo chmod 640 /etc/grafana.ini
sudo systemctl stop grafana
sudo systemctl start grafana

until curl http://admin:admin@localhost:3000/api/org ; do sleep 1 ; done
curl -H "content-type: application/json" \
    -d @grafana_prometheus_data_source.json \
    http://admin:admin@localhost:3000/api/datasources
curl -H "content-type: application/json" \
    -vvvvv \
    -d "{\"dashboard\": $(cat performance-tests.json), \"overwrite\": true}" \
    http://admin:admin@localhost:3000/api/dashboards/db
