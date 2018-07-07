FROM lsiobase/alpine.armhf:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# package versions
ARG FFMPEG_VER="3.4.2"
ARG SERVIIO_VER="1.9.2"

# environment settings
ENV JAVA_HOME="/usr/bin/java"

# copy patches
COPY patches/ /tmp/patches/

RUN \
 echo "**** change abc home folder ****" && \
 usermod -d /config/serviio abc && \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	alsa-lib-dev \
	bzip2-dev \
	coreutils \
	curl \
	g++ \
	gcc \
	git \
	gnutls-dev \
	imlib2-dev \
	jasper-dev \
	jpeg-dev \
	lame-dev \
	lcms2-dev \
	libass-dev \
	libtheora-dev \
	libva-dev \
	libvorbis-dev \
	libvpx-dev \
	libvpx-dev \
	libxfixes-dev \
	make \
	opus-dev \
	perl \
	rtmpdump-dev \
	sdl-dev \
	tar \
	v4l-utils-dev \
	x264-dev \
	x265-dev \
	xvidcore-dev \
	yasm \
	zlib-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	alsa-lib \
	expat \
	gmp \
	gnutls \
	jasper \
	jpeg \
	lame \
	lcms2 \
	libass \
	libbz2 \
	libdrm \
	libffi \
	libgcc \
	libjpeg-turbo \
	libogg \
	libpciaccess \
	librtmp \
	libstdc++ \
	libtasn1 \
	libtheora \
	libva \
	libvorbis \
	libvpx \
	libx11 \
	libxau \
	libxcb \
	libxdamage \
	libxdmcp \
	libxext \
	libxfixes \
	libxshmfence \
	libxxf86vm \
	mesa-gl \
	mesa-glapi \
	nettle \
	openjdk8-jre \
	opus \
	p11-kit \
	sdl \
	ttf-dejavu \
	v4l-utils-libs \
	x264-libs \
	x265 \
	xvidcore && \
 echo "**** compile ffmpeg ****" && \
 mkdir -p /tmp/ffmpeg-src && \
 curl -o \
 /tmp/ffmpeg.tar.bz2 -L \
	"http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.bz2" && \
 tar xf \
 /tmp/ffmpeg.tar.bz2 -C \
	/tmp/ffmpeg-src --strip-components=1 && \
 cd /tmp/ffmpeg-src && \
 for i in /tmp/patches/*.patch; do patch -p1 -i $i; done && \
 ./configure \
	--disable-debug \
	--disable-static \
	--disable-stripping \
	--enable-avfilter \
	--enable-avresample \
	--enable-gnutls \
	--enable-gpl \
	--enable-libass \
	--enable-libmp3lame \
	--enable-libopus \
	--enable-librtmp \
	--enable-libtheora \
	--enable-libv4l2 \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libx265 \
	--enable-libxcb \
	--enable-libxvid \
	--enable-pic \
	--enable-postproc \
	--enable-pthreads \
	--enable-shared \
	--enable-vaapi \
	--prefix=/usr && \
 make && \
 gcc -o tools/qt-faststart $CFLAGS tools/qt-faststart.c && \
 make doc/ffmpeg.1 doc/ffplay.1 doc/ffserver.1 && \
 make install install-man && \
 install -D -m755 tools/qt-faststart /usr/bin/qt-faststart && \
 echo "**** install serviio app ****" && \
 mkdir -p \
	/app/serviio && \
 curl -o \
 /tmp/serviio.tar.gz -L \
	http://download.serviio.org/releases/serviio-$SERVIIO_VER-linux.tar.gz && \
 tar xf /tmp/serviio.tar.gz -C \
	/app/serviio --strip-components=1 && \
 echo "**** compile dcraw ****" && \
 cp /tmp/patches/dcraw.c /usr/bin/dcraw.c && \
 cd /usr/bin && \
 gcc -o dcraw -O4 dcraw.c -lm -ljasper -ljpeg -llcms2 && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 23423/tcp 23424/tcp 8895/tcp 1900/udp
VOLUME /config /transcode
