# What is it?
Helpers for integration of tesla_dashcam + teslausb + pigallery2 for Raspberry Pi via
docker.

The basic idea is to setup *teslausb* to rsync files to a Raspberry Pi, use a script in
this repository to process them via *tesla_dashcam* and then move them to a directory
where they can be displayed via *pigallery2* through a web browser. All of this should
be automated.

# What is the Tesla referral code?

Here: https://ts.la/simon17931

# Installation instructions?
This repo builds a docker image that contains ffmpeg and everything needed to run
telsa_dashcam.

docker-compose.yml
video

# What do you need?

* A Raspberry Pi Zero W for telsausb
* A Raspberry Pi 3B+/4 for the server
* Good quality SD cards for both Raspberries
