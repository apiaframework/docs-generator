# Rapid Doc Generator

This is a middleman site that accepts a Rapid schema JSON file and an, optional, config YAML file and generates documentation as appropriate.

## Using

The best way to generate some docs is to use the Docker image.

- Mount a directory containing a `schema.json` and a `config.yaml` file into `/config`
- Mount `/output` to a directory on your local machine
- Run the image and the output will be created in the `/output` directory for you to do with what you please.

## Building the image

The actual Docker image is configured to automatically build to the `latest` tag whenever this repository is pushed to therefore you shouldn't need to do much assuming Buddy is running.

## Developing

To develop locally, you can just run up the middleman server via. Procodile which will use the example data. You might want to replace `example-schema.json` with a newer/different schema.

```
procodile start -f
```
