# Grafana Dashboard for Rocketpool
Unofficial little hack to get a grafana dashboard for RocketPool

Tested with:
- RocketPool v0.0.9
- Prysm 1.0.3
- Lighthouse v1.0.3

Exceedingly unlikely to work with any other version(s) of RocketPool or the client.

# Setup and use

## Step 1 - get and prepare the project

From your home directory - `cd ~` - clone the project:<br />
`git clone https://github.com/yorickdowne/grafana-for-rpool.git && cd grafana-for-rpool`

Copy the `default.env` file to `.env`:<br />
`cp default.env .env`

If you are using Prysm, edit `.env` to set the `CLIENT=prysm` variable:
`nano .env`

Likewise, if you need Grafana on a port other than 3000, edit the `.env` file and set
the desired port.

> Make sure to save as `.env`, do not rename the file

## Step 2 - configure RocketPool to make metrics available

### Prysm

Edit the shell scripts that start beacon and validator and add `--monitoring-host 0.0.0.0` to the line that starts beacon and validator.

For beacon:<br />
`nano ~/.rocketpool/chains/eth2/start-beacon.sh`

The startup line might then look like this:<br />
`<Original Line ends with --rpc-port 5052> --monitoring-host 0.0.0.0`

For validator:<br />
`nano ~/.rocketpool/chains/eth2/start-validator.sh`

The startup line might then look like this:<br />
`<Original Line ends with --graffiti="$GRAFFITI"> --monitoring-host 0.0.0.0`

### Lighthouse

Edit the shell script that starts beacon and validator and add `--metrics --metrics-address 0.0.0.0` to the line that starts beacon and validator.

For beacon:<br />
`nano ~/.rocketpool/chains/eth2/start-beacon.sh`

The startup line might then look like this:<br />
`<Original line ends with --http-port 5052> --metrics --metrics-address 0.0.0.0`

For validator:<br />
`nano ~/.rocketpool/chains/eth2/start-validator.sh`

The startup line might then look like this:<br />
`<Original Line ends with --graffiti="$GRAFFITI"> --metrics --metrics-address 0.0.0.0`

### Geth

If you are using Geth for eth1, edit the shell script that starts it and add `--metrics --metrics.expensive --pprof --pprof.addr=0.0.0.0` to the `CMD=` line before the closing `"`.

`nano ~/.rocketpool/chains/eth1/start-node.sh`

The CMD line might then look like this:<br />
`<Original Line ends with --http.vhosts '*'> --metrics --metrics.expensive --pprof --pprof.addr=0.0.0.0"`

> Note this needs to go *inside* the closing `"` on that line.

### And restart the rocketpool services

Caution: Eth1 and eth2 will partially resync. You may be down for a few hours.

`rocketpool service pause && rocketpool service start`

## Step 3 - start the project

`cd ~/grafana-for-rpool && docker-compose up -d grafana`

## Step 4 - security note

Grafana is insecure http and there is no reverse proxy included in this project. Do not expose the Grafana port to the Internet. You
can use an [SSH tunnel](https://www.howtogeek.com/168145/how-to-use-ssh-tunneling/) to the RocketPool node's host to get to the Grafana dashboard, if you are remote.

If you are using a VPS, see notes on [cloud security](CLOUD.md) on how you might restrict access to Grafana, if your hosting provider
does not offer security policies / a firewall.

## Step 5 - configure Grafana dashbaord

* Connect to http://YOURSERVERIP:3000/ (or the specific port you gave Grafana), log in as admin/admin, set a new password
* A number of dashboards come pre-configured. You can add additional ones through the JSON Import function if you like: Plus sign on the left bar, and then "Import"

## Addendum - expected data

- It will take a while for validator and beacon data to populate, the chains need to sync first after the disruption
- The validator can't show you earnings until it's been running for a period of time.
- Metanull's dashboard was designed for running node_exporter on the host itself. Only memory usage, disk usage and CPU will populate, the rest will be blank. You can remove those panels if you like.

## Addendum - updating this project

To update this project when it adds functionality, run these lines one by one:

```
cd ~/grafana-for-rpool
docker-compose down
git pull
docker-compose build --pull
docker-compose up -d grafana
```

LICENSE: MIT
