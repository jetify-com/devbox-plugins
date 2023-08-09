# RabbitMQ Plugin

Plugin for the [`rabbitmq-server`](https://www.nixhub.io/packages/rabbitmq-server) package. This plugin sets several `RABBITMQ` environment variables to run an instance of RabbitMQ in your local project, adds a `rabbitmq.conf` file to the devbox.d directory, and configures a RabbitMQ service.

## How to Activate

To install RabbitMQ, run `devbox add rabbitmq-server@latest`

To activate this plugin, add the following reference to the `include` section of your `devbox.json` file.

```json

"include": [
    "github:jetpack-io/devbox-plugins?dir=rabbitmq"
],
```

## Services

* rabbitmq

Use `devbox services up rabbitmq` to start the RabbitMQ  server

## Files

This plugin creates the following helper files:

* **devbox.d/rabbitmq/conf.d/rabbitmq.conf** - RabbitMQ configuration file
* **.devbox/virtenv/rabbitmq/process-compose.yaml** - Defines the process to start the RabbitMQ server

## Environment Variables

This plugin sets the following environment variables:

* **RABBITMQ_CONFIG_FILE** = {{.DevboxDir}}/conf.d
* **RABBITMQ_MNESIA_BASE** = {{.Virtenv}}/mnesia
* **RABBITMQ_ENABLED_PLUGINS_FILE** = {{.DevboxDir}}/conf.d/enabled_plugins
* **RABBITMQ_LOG_BASE** = {{.Virtenv}}/log
* **RABBITMQ_NODENAME** = rabbit
* **RABBITMQ_PID_FILE** = {{.Virtenv}}/pid/$RABBITMQ_NODENAME.pid