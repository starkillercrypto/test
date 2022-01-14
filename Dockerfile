FROM python:3.7.6-stretch AS base
COPY . .
RUN pip install pip --upgrade
RUN pip install ansible

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    sshpass

WORKDIR /work

FROM python:3.7-alpine3.9 as cli

    python-version=3.7

ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONIOENCODING=UTF-8

RUN apk add --no-cache jq

ARG AWS_CLI_VERSION

RUN pip install --user awscli==$AWS_CLI_VERSION

ENTRYPOINT [ "aws" ]
# Expose volume for adding credentials
VOLUME ["~/.aws"]
RUN mv credentials ~/.aws/credentials
RUN mv config ~/.aws/config
ENTRYPOINT ["/usr/bin/aws"]
CMD ["--version"]

FROM ubuntu:18.04 AS runtime-image

COPY --from=base . .
COPY --from=cli . .
