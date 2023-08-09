# Devbox Plugins

This repository includes plugins for configuring packages using Devbox.

## Available Plugins

* MongoDB
* RabbitMQ

## How to Use

Each subfolder contains a plugin for a specific package. To use a plugin, add the following reference to the `include` section of your `devbox.json` file.

```json
"includes": [
    "github:jetpack-io/devbox-plugins?dir=<plugin-name>"
],
```
