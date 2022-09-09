FROM public.ecr.aws/ubuntu/ubuntu:22.04 AS base

ARG DEBIAN_FRONTEND="noninteractive"

LABEL maintainer="MOIA GmbH" \
  org.label-schema.name="Codebuild Image Ubuntu" \
  org.label-schema.organization="MOIA OSS"

# -----------------------Begin: environment -----------------------
# Language Version

ENV DEFAULT_GO_VERSION="1.18"
ENV DEFAULT_NODEJS_VERSION="16"
ENV DEFAULT_JAVA_VERSION="11"

ENV GO_VERSION=$DEFAULT_GO_VERSION
ENV NODEJS_VERSION=$DEFAULT_NODEJS_VERSION
ENV JAVA_VERSION=$DEFAULT_JAVA_VERSION

# OS specific
ENV LC_CTYPE="C.UTF-8"

COPY entrypoint.sh /entrypoint/entrypoint.sh
COPY ./tools/latest_minor_go_version.sh /usr/local/bin

WORKDIR /build

# install base tools and utilities, git, SSH, aws, ...
# -----------------------Begin: base-setup -----------------------
RUN set -ex \
    && apt-get -qq update \
    && apt-get -qq --yes upgrade \
    && apt-get install -y -qq apt-transport-https gnupg ca-certificates \
    && apt-get install -y -qq --no-install-recommends software-properties-common openssh-client \
    && mkdir ~/.ssh \
    && touch ~/.ssh/known_hosts \
    && ssh-keyscan -t rsa,dsa -H github.com >> ~/.ssh/known_hosts \
    && chmod 600 ~/.ssh/known_hosts \
    && chmod 700 /usr/local/bin/latest_minor_go_version.sh \
    && apt-get install -y -qq --no-install-recommends \
        git make zip curl locales jq mlocate python3 pip openssl python3-openssl \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 99 \
    && pip3 --quiet install awscliv2 awscurl \
    && awscliv2 --install \
    && ln -s $HOME/.awscliv2/binaries/aws /usr/local/bin/aws \
    && rm -rf /var/lib/apt/lists/*

# install language specific runtimes and utilities
# -----------------------Begin: runtimes -----------------------
FROM base AS runtimes

#nodejs
ARG SRC_DIR="/usr/src"
ARG N_SRC_DIR="$SRC_DIR/n"
RUN git clone https://github.com/tj/n $N_SRC_DIR \
     && cd $N_SRC_DIR && make install \
     && rm -rf $N_SRC_DIR

# go
RUN git clone https://github.com/syndbg/goenv.git $HOME/.goenv
ENV PATH="/root/.goenv/shims:/root/.goenv/bin:/go/bin:$PATH"
ENV GOENV_DISABLE_GOPATH=1
ENV GOPATH="/go"

# java (corretto)
RUN  curl --silent --output /tmp/corretto.key https://apt.corretto.aws/corretto.key \
     && apt-key add /tmp/corretto.key \
     && echo "deb https://apt.corretto.aws stable main" > /etc/apt/sources.list.d/java.list \
     && apt-get update \
     && apt-get install -y java-${DEFAULT_JAVA_VERSION}-amazon-corretto-jdk

# -----------------------Begin: moia codebuild image -----------------------
FROM runtimes AS moia_codebuild

# pin runtime versions to image defaults

## nodejs
RUN echo "configuring n to use node version $NODEJS_VERSION..." \
    && n $NODEJS_VERSION \
    && npm install -g aws-cdk

## go
RUN echo "configuring goenv to use go version $GO_VERSION..." \
    && export GO_LATEST_MINOR_VERSION=$(latest_minor_go_version.sh $GO_VERSION) \
    && goenv install $GO_LATEST_MINOR_VERSION \
    && goenv global $GO_LATEST_MINOR_VERSION

ENTRYPOINT ["/entrypoint/entrypoint.sh"]

CMD ["/bin/bash"]
