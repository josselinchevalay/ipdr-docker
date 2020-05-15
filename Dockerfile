FROM forgerock/git:6.0.0 as git

RUN git clone https://github.com/jvassev/image2ipfs ~/image2ipfs

FROM golang:1.10 as builder

WORKDIR /go/src/github.com/jvassev/image2ipfs

COPY --from=git /opt/forgerock/image2ipfs .

RUN make nested-build GIT_VERSION=v0.1.0

FROM debian@sha256:bf338ddc710dfb9b907a29ba661b35d0f6b3eae043515c4315f64c6e93409e94

LABEL MAINTAINER=chamalow <@qio8/4L4vnzq3qRD0dqKI7sTpey54u8ZWbaICfpJOZw=.ed25519>

ENV DEBIAN_FRONTEND noninteractive
ENV IPFS_VERSION v0.5.1

RUN apt-get update -y && \
    apt-get install -y wget=1.20.3-1+b2  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd docker && \
    useradd -ms /bin/bash astroport && \
    usermod -a -G docker astroport

RUN wget https://dist.ipfs.io/go-ipfs/${IPFS_VERSION}/go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz && \
    tar xvfz go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz

WORKDIR /go-ipfs

RUN bash install.sh

WORKDIR /

COPY --from=builder /go/bin/image2ipfs /usr/local/bin

EXPOSE 5000
EXPOSE 5001
EXPOSE 4001
EXPOSE 8080

USER astroport
WORKDIR /home/astroport

RUN mkdir .ipfs

VOLUME ["/home/astroport/.ipfs"]

ENTRYPOINT [ "/bin/bash" ]

CMD ["-c", " if [ ! -e /home/astroport/.ipfs/version ]; then ipfs init; fi  && ipfs daemon --migrate=true &  image2ipfs server"]