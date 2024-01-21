# What is it?
Helpers for integration of tesla_dashcam + teslausb + pigallery2 for Raspberry Pi via
docker.

The basic idea is to setup *teslausb* to rsync files to a Raspberry Pi, use a script in
this repository to process them via *tesla_dashcam* and then move them to a directory
where they can be displayed via *pigallery2* through a web browser. All of this should
be automated.

# What is the Tesla referral code?

Not that it matters anymore, but here: https://ts.la/simon17931

# What do you need

* A Raspberry Pi Zero W for telsausb
* A Raspberry Pi 3B+/4 for the server
* Good quality SD cards for both Raspberries
* (Probably) an external harddisk for the server Pi

# TeslaUSB instructions
I use the rsync archive method with TeslaUSB to transfer clips to the server. See
[doc/teslausb_setup_variables.conf](./doc/teslausb_setup_variables.conf) for my setup,
and refer to [the TeslaUSB
rsync instructions](https://github.com/marcone/teslausb/blob/main-dev/doc/SetupRSync.md) for information about how to setup SSH keys.

# Installation instructions
This repo builds a docker image that contains ffmpeg and everything needed to run
telsa_dashcam with GPU acceleration on a Raspberry Pi 3B+ or 4.

The easiest way to use it is to copy the snippet from [`docker-compose.yml`](./docker-compose.yml) in this
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

Note! `simonkagstrom/tesla_dashcam_manager:latest` is built for 64-bit mode (AARCH64),
so make sure your Raspberry Pi is running a 64-bit OS. The last 32-bit build is
`simonkagstrom/tesla_dashcam_manager:2`.

# docker-compose.yml configuration options
Environment variables are used to setup tesla dashcam manager,

* `TZ`, the timezone to use
* `TESLA_DASHCAM_ARGUMENTS`, arguments passed to tesla dashcam.
* `RETAIN_DAYS`, how many days clips in the raw-storage are kept. 0 means forever
* `DESTINATION_RETAIN_DAYS`, how many days processed clips are kept. 0 means forever

# Screenshot of the web interface

 ![PiGallery2 screenshot](pigallery.png)
