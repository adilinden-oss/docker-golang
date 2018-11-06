# docker-golang

Docker containers for [The Go Programming Language] images.

## Why

I am trying to figure out why a golang app builds fine locally using [Docker "Official Image"] for [golang] but randomly fails on [Travis CI]. The particular issue is that there seems to be no offical [golang] image based on [Ubuntu] release [trusty] which is used by [Travis CI].


[The Go Programming Language]: (https://golang.org/)
[Docker "Official Image"]: (https://docs.docker.com/docker-hub/official_repos/)
[golang]: (https://hub.docker.com/_/golang/)
[Travis CI]: (https://travis-ci.com/)
[Ubuntu]: (https://www.ubuntu.com/)
[trusty]: (http://releases.ubuntu.com/trusty/)

## Usage

These images can be used similar fashion to the [Docker "Official Image"] for [golang].

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

