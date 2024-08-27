# Grafana Plugin

Plugin for the [`grafana`](https://www.nixhub.io/packages/grafana) package. This plugin configures MonogoDB to use a local config file and data directory for this project, and configures the grafana server as a service.

## How to Activate

To install Grafana, run `devbox add grafana@latest`. 

To activate this plugin, add the following reference to the `include` section of your `devbox.json` file.

```json

"include": [
    "github:jetify-com/devbox-plugins?dir=grafana"
],
```

## Services

* grafana

Use `devbox services up grafana` to start the mongodb server.

## Files

This plugin creates the following helper files:

* **devbox.d/grafana/conf/defaults.ini** - a default grafana config
* **.devbox/virtenv/grafana/process-compose.yaml** - Defines the process to start the Grafana server

## Environment Variables

This plugin sets the following environment variables:

* **$GRAFANA_DATA_DIR**: ".devbox/virtenv/grafana/lib",
* **$GRAFANA_LOG_DIR**: ".devbox/virtenv/grafana/log",
* **$GRAFANA_PLUGIN_DIR**: "devbox.d/grafana/plugins",
* **$GRAFANA_HOMEPATH**: ".devbox/virtenv/grafana",
* **$GRAFANA_CONFIG_DIR**: "devbox.d/grafana/conf",
* **$GRAFANA_PROVISIONING_DIR**: ".devbox/virtenv/grafana/conf/provisioning"

## Other Details

This plugin will copy the Grafana server's public files to `.devbox/virtenv/grafana/public` when you start your shell
