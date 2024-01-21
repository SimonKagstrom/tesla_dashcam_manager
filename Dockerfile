FROM balenalib/aarch64-alpine:3.18

RUN apk --no-cache upgrade
RUN apk add --no-cache python3 py3-pip py3-pip font-freefont ffmpeg bash py3-pillow py3-psutil py3-tzlocal py3-wheel py3-dateutil

RUN python3 -m pip install --upgrade pip
RUN pip3 install staticmap

RUN mkdir /usr/share/fonts/truetype
RUN ln -s /usr/share/fonts/freefont/ /usr/share/fonts/truetype/freefont
# Not really true, but anyway
RUN ln -s /usr/share/fonts/truetype/freefont/FreeSans.otf /usr/share/fonts/truetype/freefont/FreeSans.ttf

COPY src/tesla_dashcam_manager.py /usr/bin/
COPY tesla_dashcam/tesla_dashcam/tesla_dashcam.py /usr/bin/
RUN chmod +x /usr/bin/tesla*.py

CMD python3 /usr/bin/tesla_dashcam_manager.py /app/staging /app/raw-storage /app/destination-path /usr/bin/tesla_dashcam.py "${TESLA_DASHCAM_ARGUMENTS}" ${RETAIN_DAYS} ${DESTINATION_RETAIN_DAYS}
