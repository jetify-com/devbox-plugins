# MongoDB Plugin

Plugin for the [`mongodb`](https://www.nixhub.io/packages/mongodb) package. This plugin configures MonogoDB to use a local config file and data directory for this project, and configures a mongodb service.

## How to Activate

To install MongoDB, run `devbox add mongodb@latest`. We also recommend installing the [`mongosh`](https://nixhub.io/packages/mongosh) client with `devbox add mongosh@latest`.

To activate this plugin, add the following reference to the `include` section of your `devbox.json` file.

```json

"include": [
    "github:jetpack-io/devbox-plugins?dir=mongodb"
],
```

## Services

* mongodb

Use `devbox services up mongodb` to start the mongodb server.

## Files

This plugin creates the following helper files:

* **devbox.d/mongodb/mongod.conf** - MongoDB configuration file
* **.devbox/virtenv/mongodb/data** - empty directory for holding your mongodb database
* **.devbox/virtenv/mongodb/process-compose.yaml** - Defines the process to start the MongoDB server

## Environment Variables

This plugin sets the following environment variables:

* **MONGODB_CONFIG** = {{.DevboxDir}}/mongod.conf
* **MONGODB_DATA** = {{.Virtenv}}/data
