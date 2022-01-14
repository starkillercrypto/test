FROM python:3.7.6-stretch AS base
COPY . .
RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

WORKDIR /work
FROM gliderlabs/alpine:3.6 as cli
MAINTAINER Stuart Wong <cgs.wong@gmail.com>
COPY . .
ENV PAGER="less -r"

RUN apk --no-cache add \
      bash \
      less \
      curl \
      jq \
      groff \
      py-pip \
      python &&\
    pip install --upgrade \
      pip \
      awscli &&\
    mkdir ~/.aws
# Expose volume for adding credentials
VOLUME ["~/.aws"]
RUN mv credentials ~/.aws/credentials

ENTRYPOINT ["/usr/bin/aws"]
CMD ["--version"]

FROM ubuntu:18.04 AS runtime-image

COPY --from=base . .
COPY --from=cli . .
