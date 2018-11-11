# About

Docker containers for [The Go Programming Language]

## Tags

- `latest` [master/trusty/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/trusty/Dockerfile)
- `1.9.5-trusty`, [v1.9.5-trusty/trusty/Dockerfile](https://github.com/adilinden/docker-golang/blob/v1.9.5-trusty/trusty/Dockerfile)

### Docker Hub 'Build Settings'

| Type   | Name                    | Dockerfile Location | Docker Tag Name  |
|--------|-------------------------|---------------------|------------------|
| Branch | master                  | /trusty/            | latest           |
| Tag    | /^v[0-9.]+-trusty$/     | /trusty/            | trusty           |
| Tag    | /^v([0-9.]+-trusty)$/   | /trusty/            | {\1}             |
| Tag    | /^v[0-9.]+-buster$/     | /buster/            | buster           |
| Tag    | /^v([0-9.]+-buster)$/   | /buster/            | {\1}             |

## Why?

The [Docker Official golang] is currently based on [Debian] [stretch] and [Alpine] Linux. This presents an issue when trying to identify an issue that seems to be unique to building a [golang] app on [Travic CI] as [Travis CI] uses a [Ubuntu] [trusty] base.

## Usage

These images can be used similar fashion to the [Docker Official golang] image.

### Build an app

Create a docker file like

    FROM adilinden/golang

    WORKDIR /go/src/app
    COPY . .

    RUN go get -d -v ./...
    RUN go install -v ./...

    CMD ["app"]
    You can then build and run the Docker image:

    $ docker build -t my-golang-app .
    $ docker run -it --rm --name my-running-app my-golang-app

### Compile an app using container

Compile an app using the containers `go` environment.

    docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp adilinden/golang go build -v

### Compile an app inside container

This is what I created it for.

    docker run --rm -it --name go-debug-app adilinden/golang:trusty /bin/bash

    go get -v github.com/adilinden/oauth2_proxy \
        && cd $GOPATH/src/github.com/adilinden/oauth2_proxy \
        && go get -t -v ./... \
        && ./test.sh


[The Go Programming Language]: https://golang.org/
[Docker Official golang]: https://hub.docker.com/_/golang/
[Travis CI]: https://travis-ci.com/
[Debian]: https://www.debian.org/
[stretch]: https://wiki.debian.org/DebianStretch
[Alpine]: https://alpinelinux.org/
[Ubuntu]: https://www.ubuntu.com/
[trusty]: http://releases.ubuntu.com/trusty/
[Docker Hub]: https://hub.docker.com/


