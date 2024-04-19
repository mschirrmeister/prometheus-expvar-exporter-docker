# prometheus-expvar-exporter Docker

This project provides a __Dockerfile__ for the [prometheus-expvar-exporter](https://github.com/albertito/prometheus-expvar-exporter) project.

**prometheus-expvar-exporter** connects to a service which exposes it's metrics via the [expvar](http://golang.org/pkg/expvar/) package and exports them for [Prometheus](https://prometheus.io/).

Below are a few examples on how to run the container.

## Examples

Run the container with own custom configuration.

    docker run -it -d \
      --name prometheus-expvar-exporter \
      -p 8000:8000/tcp \
      -v ./config.toml:/app/config.toml \
      mschirrmeister/prometheus-expvar-exporter:latest

