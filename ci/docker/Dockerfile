FROM ubuntu:jammy

COPY --from=bosh/bosh-ecosystem-concourse:latest /usr/local/bin/bosh /usr/local/bin/bosh

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        wget \
        gcc \
        git \
        git-lfs \
        jq \
        libssl-dev \
        libncurses-dev \
        zlib1g-dev

ADD . /tmp/release

RUN set -x && cd /tmp/release && \
    mkdir -p /var/vcap/packages && mkdir -p /var/vcap/data && \
    wget https://github.com/erlang/otp/releases/download/OTP-26.1.2/otp_src_26.1.2.tar.gz && \
    wget https://github.com/elixir-lang/elixir/archive/v1.15.6.tar.gz

RUN set -x && cd /tmp/release && \
    for package in $(ls /tmp/release/packages | grep otp- | grep -v test); do \
        rm -rf /tmp/workspace && \
        mkdir /tmp/workspace && \
        cp -r /tmp/release/src/* /tmp/workspace/ && \
        chmod +x /tmp/release/packages/$package/packaging && \
        mkdir -p /var/vcap/packages/$package && \
        cp /tmp/release/otp_src_26.1.2.tar.gz /tmp/workspace/ && \
        cd /tmp/workspace && \
        BOSH_INSTALL_TARGET=/var/vcap/packages/$package /tmp/release/packages/$package/packaging && \
        cd /tmp; \
    done

RUN set -x && cd /tmp/release && \
    for package in $(ls /tmp/release/packages | grep elixir- | grep -v test); do \
        rm -rf /tmp/workspace && \
        mkdir /tmp/workspace && \
        cp -r /tmp/release/src/* /tmp/workspace/ && \
        chmod +x /tmp/release/packages/$package/packaging && \
        mkdir -p /var/vcap/packages/$package && \
        cp /tmp/release/v1.15.6.tar.gz /tmp/workspace/ && \
        cd /tmp/workspace && \
        BOSH_INSTALL_TARGET=/var/vcap/packages/$package /tmp/release/packages/$package/packaging && \
        cd /tmp; \
    done

RUN rm -r /tmp/release /tmp/workspace
