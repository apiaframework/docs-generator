# Rapid Doc Generator

This is a middleman site that accepts a Rapid schema JSON file and an, optional, config YAML file and generates documentation as appropriate.

## Using

The best way to generate some docs is to use the Docker image.

- Mount a directory containing a `schema.json` and a `config.yaml` file into `/config`
- Mount `/output` to a directory on your local machine
- Run the image and the output will be created in the `/output` directory for you to do with what you please.

## Building the image

To build the image, you can simply use these commands:

- `make docker-image` - builds the image locally
- `make docker-release` - builds and releases the image

## Developing

To develop locally, you can just run up the middleman server via. Procodile which will use the example data. You might want to replace `example-schema.json` with a newer/different schema.

```
procodile start -f
```
