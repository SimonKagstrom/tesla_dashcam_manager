# What is it?
Helpers for integration of tesla_dashcam + teslausb + pigallery2 for Raspberry Pi via
docker.

The basic idea is to setup *teslausb* to rsync files to a Raspberry Pi, use a script in
this repository to process them via *tesla_dashcam* and then move them to a directory
where they can be displayed via *pigallery2* through a web browser. All of this should
be automated.

# What is the Tesla referral code?

Here: https://ts.la/simon17931

# What do you need?

* A Raspberry Pi Zero W for telsausb
* A Raspberry Pi 3B+/4 for the server
* Good quality SD cards for both Raspberries
* (Probably) an external harddisk for the server Pi

# Installation instructions?
This repo builds a docker image that contains ffmpeg and everything needed to run
telsa_dashcam on a Raspberry Pi 3B+ or 4.

The easiest way to use it is to copy the snippet from `docker-compose.yml` in this
repository into your own `docker-compose.yml`, where you probably already run Teslamate
and pigallery2.

On the server, create `staging`, `raw-storage` and a `destination-path` to use with
tesla_dashcam_manager. These are

* `staging`: The path where clips comes in from Teslausb
* `raw-storage`: The path where raw clips are stored for future use (removed after
  one year by default)
* `destination-path`: Where the processed clips end up, should be readable by pigallery2

After having updated your `docker-compose.yml`, do

```
# Create staging, raw-storage and destination-path
mkdir -p /mnt/staging /mnt/raw-storage /mnt/photos/TeslaCam
docker-compose pull
docker-compose up -d
```

and you should be up and running.
# Screenshot of the web interface

 ![PiGallery2 screenshot](pigallery.png)
