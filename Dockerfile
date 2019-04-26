FROM amd64/debian:jessie-slim

RUN uname -a && apt-get update --quiet && apt-get install --quiet --yes netselect-apt
RUN cd /etc/apt && netselect-apt && apt-get update
RUN apt-get dist-upgrade --quiet --yes

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
    curl -sL https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz | \
    tar -zx -C /usr/local
ENV PATH "${PATH}:/usr/local/go/bin"

RUN apt-get install --quiet --yes zip p7zip-full

