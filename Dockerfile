FROM python:3.7.6-stretch AS base
COPY . .
RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

WORKDIR /work

FROM ubuntu:18.04 AS runtime-image

COPY --from=compile-image . .
