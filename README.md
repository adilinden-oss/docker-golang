# docker-golang

Docker containers for [The Go Programming Language] images.

## Tags

### Ubuntu

o `1.11.2-trusty`, `1.11.1-trusty`, `1.11-trusty`, `trusty`, `latest` [trusty/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/trusty/Dockerfile)
o `1.10.5-trusty`, `1.10-trusty` [trusty/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/trusty/Dockerfile)
o `1.9.7-trusty`, `1.9-trusty` [trusty/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/trusty/Dockerfile)

### Debian

o `1.11.2-buster`, `1.11.1-buster`, `1.11-buster`, `buster` [buster/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/buster/Dockerfile)
o `1.10.5-buster`, `1.10-buster` [buster/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/buster/Dockerfile)
o `1.9.7-buster`, `1.9-buster` [buster/Dockerfile](https://github.com/adilinden/docker-golang/blob/master/buster/Dockerfile)

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

## Building

The build script `build.sh` will build all images and push them to Docker hub. The following locations are searched for Dockerfiles. The first match wins.

    os_ver/Dockerfile
    golang_ver/os_ver/Dockerfile

To use the build script, make sure you're logged into a Docker registry. Run `build.sh` with registry username as argument.

    docker login
    ./build.sh

Watch the show...

## To Do

Learn about continuous integration....


