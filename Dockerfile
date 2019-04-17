FROM tianon/debian:jessie

RUN uname -a && apt-get update --quiet && apt-get install --quiet --yes netselect-apt
RUN cd /etc/apt && netselect-apt && apt-get update
RUN apt-get dist-upgrade --quiet --yes

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install --quiet --yes nodejs

RUN apt-get install --quiet --yes build-essential
RUN apt-get install --quiet --yes cmake
RUN apt-get install --quiet --yes git
RUN apt-get install --quiet --yes autoconf automake bzip2 libtool nasm perl pkg-config python yasm zlib1g-dev intltool
RUN apt-get install --quiet --yes libx11-dev
RUN apt-get install --quiet --yes libasound2-dev
RUN apt-get install --quiet --yes zip p7zip-full

RUN \
	curl -sL https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz | \
	tar -zx -C /usr/local

RUN \
        SRC=/usr/capsule && \
        export PKG_CONFIG_PATH=${SRC}/lib/pkgconfig && \
        SNDFILE_VERSION=1.0.27 && \
        DIR=$(mktemp -d) && cd ${DIR} && \
# libsndfile http://www.mega-nerd.com/libsndfile/
        curl -sL http://www.mega-nerd.com/libsndfile/files/libsndfile-${SNDFILE_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --disable-sqlite --disable-alsa --disable-external-libs --disable-octave && \
        make -j2 && \
        make install && \
        rm -rf ${DIR}

RUN \
        SRC=/usr/capsule && \
        export PKG_CONFIG_PATH=${SRC}/lib/pkgconfig && \
        PULSE_VERSION=10.0 && \
        DIR=$(mktemp -d) && cd ${DIR} && \
# pulseaudio https://www.freedesktop.org/wiki/Software/PulseAudio/
        curl -sL https://freedesktop.org/software/pulseaudio/releases/pulseaudio-${PULSE_VERSION}.tar.xz | \
        tar -Jx --strip-components=1 && \
        ./configure --prefix="${SRC}" --disable-x11 --disable-tests --disable-oss-wrapper \
          --disable-coreaudio-output --disable-esound --disable-solaris --disable-waveout \
          --disable-glib2 --disable-gtk3 --disable-gconf --disable-avahi --disable-jack \
          --disable-asyncns --disable-tcpwrap --disable-lirc --disable-dbus --disable-bluez4 \
          --disable-bluez5 --disable-bluez5-ofono-headset --disable-bluez5-native-headset \
          --disable-hal-compat --disable-ipv6 --disable-openssl --disable-systemd-daemon \
          --disable-systemd-login --disable-systemd-journal --disable-manpages --disable-per-user-esound-socket \
          --without-caps && \
        make -j2 && \
        make install && \
        rm -rf ${DIR}

# inspired from https://github.com/jrottenberg/ffmpeg
RUN \
        SRC=/usr/capsule && \
        export PKG_CONFIG_PATH=${SRC}/lib/pkgconfig && \
        X264_VERSION=20170328-2245-stable && \
        DIR=$(mktemp -d) && cd ${DIR} && \
## x264 http://www.videolan.org/developers/x264.html
        curl -sL http://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-pic --enable-shared --disable-cli && \
        make -j2 && \
        make install && \
        rm -rf ${DIR}

RUN \
        SRC=/usr/capsule && \
        export PKG_CONFIG_PATH=${SRC}/lib/pkgconfig && \
        FFMPEG_VERSION=3.2.4 && \
        DIR=$(mktemp -d) && cd ${DIR} && \
# ffmpeg https://ffmpeg.org/
        curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --bindir="${SRC}/bin" \
        --disable-doc \
        --disable-static \
        --enable-shared \
        --disable-ffplay \
        --extra-libs=-ldl \
        --enable-version3 \
        --enable-libx264 \
        --enable-gpl \
        --enable-avresample \
        --enable-postproc \
        --enable-nonfree \
        --disable-debug \
        --enable-small && \
        make -j2 && \
        make install && \
        make distclean && \
        rm -rf ${DIR} 

ENV PATH "${PATH}:/usr/local/go/bin"

RUN apt-get install --quiet --yes libgl1


