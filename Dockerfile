FROM amd64/ubuntu:18.04

RUN uname -a && apt-get update --quiet
RUN apt-get dist-upgrade --quiet --yes

RUN apt-get install --quiet --yes curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install --quiet --yes nodejs

RUN apt-get install --quiet --yes \
    git \
    build-essential cmake autoconf automake libtool pkg-config \
    python perl \
    bzip2 zlib1g-dev \
    yasm nasm \
    libgl1 libgl1-mesa-dev

RUN curl https://ftp.osuosl.org/pub/blfs/conglomeration/nasm/nasm-2.14.02.tar.xz | tar xJ && \
    cd nasm-2.14.02 && ./configure --host=i686-pc-linux-gnu && make -j all install

# butler deps

RUN \
    curl -sL https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz | \
    tar -zx -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"

RUN apt-get install --quiet --yes zip p7zip-full

# install rust toolchain
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y

RUN apt-get install --quiet --yes libwebkit2gtk-4.0-dev

