FROM ubuntu:22.04

LABEL maintainer="MOIA GmbH" \
  org.label-schema.name="Codebuild Image Ubuntu"

ENV DEFAULT_GO_VERSION="1.18.3"
ENV DEFAULT_NODE_VERSION="14.20.0"

COPY entrypoint.sh /build/

WORKDIR /build

# install basic tools
RUN apt-get -qq update \
    && apt-get -qq --yes upgrade \
    && apt-get --yes -qq -o=Dpkg::Use-Pty=0 install python3 pip make zip curl git \ 
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 99 \
    && pip3 --quiet install awscli awscurl

# install nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $HOME/.nvm/nvm.sh

# install goenv and go
ENV GOENV_ROOT $HOME/.goenv
ENV PATH $GOENV_ROOT/bin:$PATH

RUN git clone --quiet https://github.com/syndbg/goenv.git ~/.goenv \ 
    && echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.bashrc \
    && echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(goenv init -)"' >> ~/.bashrc \
    && echo 'export PATH="$GOROOT/bin:$PATH"' >> ~/.bashrc \ 
    && echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.bashrc

ENTRYPOINT ["./entrypoint.sh"]

CMD ["/bin/bash"]
