FROM debian@sha256:bf338ddc710dfb9b907a29ba661b35d0f6b3eae043515c4315f64c6e93409e94

LABEL MAINTAINER=chamalow <@qio8/4L4vnzq3qRD0dqKI7sTpey54u8ZWbaICfpJOZw=.ed25519>

ENV DEBIAN_FRONTEND noninteractive
ENV IPFS_VERSION v0.5.1
ENV IPDR_VERSION 0.1.6

RUN apt-get update -y && \
    apt-get install -y sudo=1.8.31p1-1 wget=1.20.3-1+b2  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash astroport

RUN wget https://dist.ipfs.io/go-ipfs/${IPFS_VERSION}/go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz && \
    tar xvfz go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz && \
    cd go-ipfs && \
    bash install.sh

WORKDIR /

RUN wget https://github.com/miguelmota/ipdr/releases/download/v${IPDR_VERSION}/ipdr_${IPDR_VERSION}_linux_amd64.tar.gz  && \
    tar -xvzf ipdr_${IPDR_VERSION}_linux_amd64.tar.gz ipdr && \
    cp ipdr /usr/local/bin/ipdr

EXPOSE 5000
EXPOSE 5001
EXPOSE 4001
EXPOSE 8080

USER astroport
WORKDIR /home/astroport

RUN mkdir .ipfs

VOLUME ["/home/astroport/.ipfs"]

ENTRYPOINT [ "/bin/bash" ]

CMD ["-c", " if [ ! -e /home/astroport/.ipfs/version ]; then ipfs init; fi  && ipfs daemon --migrate=true &  ipdr server -p 5000"]