# Grafana Dashboard for Rocketpool
Unofficial little hack to get a grafana dashboard for RocketPool

Tested with:
- RocketPool v0.0.4
- Prysm 1.0.0-alpha.29

Not yet tested with:
- Lighthouse v0.2.13 (Please get in touch if you can test)

Exceedingly unlikely to work with any other version(s) of RocketPool or the client.

# Setup and use

## Step 1 - get and prepare the project

From your home directory - `cd ~` - clone the project:<br />
`git clone https://github.com/yorickdowne/grafana-for-rpool.git && cd grafana-for-rpool`

Copy the `default.env` file to `.env`:<br />
`cp default.env .env`

If you are using Lighthouse, edit `.env` to set the `CLIENT=lighthouse` variable:
`nano .env`

Likewise, if you need Grafana on a port other than 3000, edit the `.env` file and set
the desired port.

> Make sure to save as `.env`, do not rename the file

## Step 2 - configure RocketPool to make metrics available

### Prysm

Edit the shell scripts that start beacon and validator and add `--monitoring-host 0.0.0.0` to the line that starts beacon and validator.

For beacon:<br />
`nano ~/.rocketpool/chains/eth2/start-beacon.sh`

The startup line might then look like this if `--blst` is also added:<br />
`<Original Line ends with --rpc-port 5052> --blst --monitoring-host 0.0.0.0`

For validator:<br />
`nano ~/.rocketpool/chains/eth2/start-validator.sh`

The startup line might then look like this if `--blst` is also added and the graffiti changed to the RocketPool guild:<br />
`<Original Line ends with --graffiti="$GRAFFITI"> --graffiti "guildwarz-rocket-pool" --blst --monitoring-host 0.0.0.0`

### Lighthouse

Unsure of required changes for v0.2.13, please get in touch if you want to test.

### And restart the rocketpool services

Caution: Eth1 and eth2 will partially resync. You may be down for a few hours, and during times of non-finality, the penalties
are very real. Consider how badly you want this dashboard.

`rocketpool service pause && rocketpool service start`

## Step 3 - start the project

`cd ~/grafana-for-rpool && docker-compose up -d grafana`

## Step 4 - security note

Grafana is insecure http and there is no reverse proxy included in this project. Do not expose the Grafana port to the Internet. You
can use an [SSH tunnel](https://www.howtogeek.com/168145/how-to-use-ssh-tunneling/) to the RocketPool node's host to get to the Grafana dashboard, if you are remote.

## Step 5 - configure Grafana dashbaord

* Connect to http://YOURSERVERIP:3000/ (or the specific port you gave Grafana), log in as admin/admin, set a new password

* Click on the gear icon on the left, choose "Data Sources", and "Add Data Source". Choose Prometheus, use http://prometheus:9090 as the URL, then click "Save and Test".

* Import a Dashboard. Click on the + icon on the left, choose "Import". Copy/paste JSON code from one of the client dashboard links below (click anywhere inside the page the link gets you to, use Ctrl-a to select all and Ctrl-C to copy), click "Load", if prompted choose the "prometheus" data source you just configured, click "Import". Note: The Metanull dashboard might also work with Lighthouse with small modifications, TBD.

  * [Prysm Dashboard by Metanull](https://raw.githubusercontent.com/metanull-operator/eth2-grafana/master/eth2-grafana-dashboard-single-source.json)
  * [Prysm Dashboard JSON](https://raw.githubusercontent.com/GuillaumeMiralles/prysm-grafana-dashboard/master/less_10_validators.json)
  * [Prysm Dashboard JSON for more than 10 validators](https://raw.githubusercontent.com/GuillaumeMiralles/prysm-grafana-dashboard/master/more_10_validators.json)
  * [Lighthouse Dashboard JSON](https://raw.githubusercontent.com/sigp/lighthouse-metrics/master/dashboards/Summary.json)

## Addendum - expected data

- It will take a while for validator and beacon data to populate, the chains need to sync first after the disruption
- The validator can't show you earnings until it's been running for a period of time.
- Metanull's dashboard was designed for running node_exporter on the host itself. Only memory usage, disk usage and CPU will populate, the rest will be blank. You can remove those panels if you like.


LICENSE: MIT
