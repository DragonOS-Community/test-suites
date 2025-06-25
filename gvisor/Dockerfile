FROM ubuntu:22.04

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
# RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.tencent.com@g' /etc/apt/sources.list

ENV DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y curl gnupg2 git \
        python-is-python3 python3 python3-distutils python3-pip \
        build-essential crossbuild-essential-arm64 qemu-user-static \
        openjdk-11-jdk-headless zip unzip \
        apt-transport-https ca-certificates gnupg-agent \
        software-properties-common \
        pkg-config libffi-dev patch diffutils libssl-dev iptables kmod \
        clang crossbuild-essential-amd64 erofs-utils busybox-static libbpf-dev \
        iproute2 netcat libnuma-dev pixz

# This package is needed to build eBPF on amd64, but not on arm64 where it
# doesn't exist.
RUN test "$(uname -m)" != x86_64 && exit 0 || apt-get install -y libc6-dev-i386

# Download the official bazel binary. The APT repository isn't used because there is not packages for arm64.
RUN sh -c 'curl -o /usr/local/bin/bazel https://releases.bazel.build/7.5.0/release/bazel-7.5.0-linux-$(uname -m | sed s/aarch64/arm64/) && chmod ugo+x /usr/local/bin/bazel'

# Set up working directory
WORKDIR /workspace

CMD [ "bash" ]
