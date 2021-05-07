FROM balenalib/raspberry-pi-alpine:3.12


# From https://github.com/denismakogon/ffmpeg-alpine, with changes for RPi
ENV FFMPEG_CORE="bash \
                 tzdata \
                 libass \
                 libstdc++ \
                 libpng \
                 libjpeg \
                 xvidcore \
                 x264-libs \
                 x265 \
                 libvpx \
                 libvorbis \
                 opus \
                 lame \
                 fdk-aac \
                 freetype \
                 libavc1394 \
                 yasm"

ENV BUILD_DEPS="fdk-aac-dev \
                freetype-dev \
                x264-dev \
                x265-dev \
                yasm-dev \
                libogg-dev \
                libvorbis-dev \
                opus-dev \
                libvpx-dev \
                lame-dev \
                xvidcore-dev \
                libass-dev \
                openssl-dev \
                musl-dev \
                build-base \
                libjpeg-turbo-dev \
                libpng-dev \
                libavc1394-dev \
                libavc1394-dev \
                clang-dev"

ENV FFMPEG_VERSION=4.4

RUN apk --no-cache upgrade
RUN apk add --no-cache python3 jpeg-dev zlib-dev build-base python3-dev py3-pip ttf-freefont ${FFMPEG_CORE}
RUN apk add --no-cache --virtual .build-deps ${BUILD_DEPS}

RUN export SRC=/usr \
	DIR=$(mktemp -d) && cd ${DIR} && \
	curl -Os http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
	tar xzf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
	cd ffmpeg-${FFMPEG_VERSION} && \
	./configure \
        --prefix="${SRC}" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --bindir="${SRC}/bin" \
        --extra-libs=-ldl \
        --enable-version3 \
        --enable-libmp3lame \
        --enable-pthreads \
        --enable-libx264 \
        --enable-libxvid \
        --enable-gpl \
        --enable-postproc \
        --enable-nonfree \
        --enable-avresample \
        --enable-libfdk-aac \
        --disable-debug \
        --enable-small \
        --enable-openssl \
        --enable-libx265 \
        --enable-libopus \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libfreetype \
        --enable-libass \
        --enable-omx \
        --enable-omx-rpi \
        --enable-shared \
        --enable-pic && \
    make -j4 && \
    make install && \
    make distclean && \
	hash -r && \
	cd /tmp && \
	rm -rf ${DIR} && \
	apk del .build-deps && \
    rm -rf /var/cache/apk/*

ENV LIBRARY_PATH=/lib:/usr/lib
RUN python3 -m pip install --upgrade pip
RUN pip3 install wheel
RUN pip3 install pillow
RUN pip3 install staticmap

RUN pip3 install python-dateutil
RUN pip3 install tzlocal
RUN pip3 install psutil

RUN mkdir /usr/share/fonts/truetype
RUN ln -s /usr/share/fonts/TTF /usr/share/fonts/truetype/freefont

COPY src/tesla_dashcam_manager.py /usr/bin/
COPY tesla_dashcam/tesla_dashcam/tesla_dashcam.py /usr/bin/
RUN chmod +x /usr/bin/tesla*.py

CMD python3 /usr/bin/tesla_dashcam_manager.py /app/staging /app/raw-storage /app/destination-path /usr/bin/tesla_dashcam.py "${TESLA_DASHCAM_ARGUMENTS}" ${RETAIN_DAYS}
