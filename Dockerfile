FROM balenalib/raspberry-pi-alpine:3.12

RUN apk --no-cache upgrade
RUN apk add --no-cache ffmpeg python3 jpeg-dev zlib-dev build-base python3-dev py3-pip ttf-freefont

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

# Cleanup
RUN apk del build-base

COPY src/tesla_dashcam_manager.py /usr/bin/
COPY tesla_dashcam/tesla_dashcam/tesla_dashcam.py /usr/bin/
RUN chmod +x /usr/bin/tesla*.py

CMD python3 /usr/bin/tesla_dashcam_manager.py /app/staging /app/raw-storage /app/destination-path
