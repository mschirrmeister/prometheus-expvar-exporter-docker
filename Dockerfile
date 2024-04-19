FROM golang:1.22 as builder

ENV APP_USER app
ENV APP_HOME /app
RUN groupadd $APP_USER && useradd -m -g $APP_USER -l $APP_USER
RUN mkdir -p $APP_HOME/build && chown -R $APP_USER:$APP_USER $APP_HOME
WORKDIR $APP_HOME/build
USER $APP_USER

ARG TARGETOS
ARG TARGETARCH
ARG CGO_ENABLED=0

# build master branch
# RUN git clone https://github.com/albertito/prometheus-expvar-exporter .

# build specific commit
RUN git clone https://github.com/albertito/prometheus-expvar-exporter . \
    && git checkout next \
    && git checkout 176c61fe708bccd914380fea7fe43714595efb28 \
    && git reset --hard

WORKDIR $APP_HOME/build

# https://opensource.com/article/22/4/go-build-options
RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go clean \
    && go build -ldflags="-s -w" -o prometheus-expvar-exporter \
    && cp -p prometheus-expvar-exporter $APP_HOME/

WORKDIR $APP_HOME

RUN rm -rf build

FROM alpine:3.19.1

ENV APP_HOME /app
WORKDIR $APP_HOME

ENV LOCAL_PORT 8000

COPY --chown=0:0 --from=builder $APP_HOME/prometheus-expvar-exporter $APP_HOME

ADD config.toml /app/config.toml

EXPOSE $LOCAL_PORT/tcp

ENTRYPOINT ["./prometheus-expvar-exporter"]

CMD ["--config", "/app/config.toml"]
