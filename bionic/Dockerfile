FROM ubuntu:bionic

MAINTAINER Adi Linden <adi@adis.ca>

ARG golang_ver=1.11.2
ENV GOLANG_VERSION ${golang_ver}

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        wget \
        ca-certificates \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -fr /var/cache/apt/* /var/lib/apt/lists/*

RUN set -eux; \
        dpkgArch="$(dpkg --print-architecture)"; \
        case "${dpkgArch##*-}" in \
            amd64) goRelArch='linux-amd64' ;; \
            i386) goRelArch='linux-386' ;; \
            *) \
                echo >&2; \
                echo >&2 "error: $dpkgArch UNIMPLEMENTED"; \
                echo >&2; \
                exit 1 ;; \
        esac; \
        \
        url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
        wget -O go.tgz "$url"; \
        tar -C /usr/local -xzf go.tgz; \
        rm go.tgz; \
        \
        export PATH="/usr/local/go/bin:$PATH"; \
        go version


ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

CMD ["/bin/bash", "-l"]
