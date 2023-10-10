# NATS Server Plugin

Plugin for the [`nats-server`](https://www.nixhub.io/packages/nats-server) package. This plugin configures NATS-server to use a local config, and adds a process-compose service,

## How to Activate

To install NATS Server, run `devbox add nats-server@latest`. We also recommend installing the [`natscli`](https://nixhub.io/packages/natscli) and [`nats-top`](https://nixhub.io/packages/nats-top) packages.

```bash

To activate this plugin, add the following reference to the `include` section of your `devbox.json` file.

```json

"include": [
    "github:jetpack-io/devbox-plugins?dir=nats"
],
```

## Services

* nats-server

Use `devbox services up nats-server` to start the nats server.

## Files

This plugin creates the following helper files:

* **devbox.d/nats-server/server.conf** - NATS Server configuration file
* **.devbox/virtenv/nats-server/process-compose.yaml** - Defines the process to start the MongoDB server

## Environment Variables

This plugin sets the following environment variables:

* **NATS_SERVER_CONF** = {{.DevboxDir}}/server.conf
