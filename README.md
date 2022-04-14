![Welcome](https://share.adam.ac/21/Artboard-Copy-2-hxZwwCclScJjGppfkN.png)

This is a middleman site that accepts a Apia schema JSON file and an, optional, config YAML file and generates documentation as appropriate.

## Using

The best way to generate some docs is to use the Docker image. By default, it will:

- Export generated document to the `/output` directory
- Read the schema from `/config/schema.json`
- Read configuration from `/config/config.yaml`

### Environment variables

You can specify the following environment variables to configure how docs are generated.

* `APIA_SCHEMA_URL` - download the schema from the given URL rather than reading it from `/config/schema.json`.

The following options can be used to upload the generated output to a remote SSH/SFTP server.

* `UPLOAD_HOST` - hostname to upload to
* `UPLOAD_PORT` - SSH port (defaults to 22)
* `UPLOAD_USERNAME` - the username to connect with (defaults to root)
* `UPLOAD_PASSWORD` - the password to autheticate with
* `UPLOAD_KEY_PATH` - a path to an passphrase-less SSH key within the container (you'll need to mount it)
* `UPLOAD_PATH` - the directory to upload the files to on the remote server

## Building the image

To build the image, you can simply use these commands:

- `make docker-image` - builds the image locally
- `make docker-release` - builds and releases the image

## Developing

To develop locally, you can just run up the middleman server via. Procodile which will use the example data. You might want to replace `example-schema.json` with a newer/different schema.

```
procodile start -f
```
