Introduction
----

Components needed
-----------
- Raspberry pi zero W
- >= 64GB micro SD

- Raspberry pi 3/4 or similar with plenty of disk storage

Downloading the teslausb image
---------------------
Download the latest release of teslausb from https://github.com/marcone/teslausb

Flashing the image
------------------
Raspberry pi imager

Config
------
Setup rsync+ssh to your other raspberry
Wifi

Setup of teslausb
-----------------
Plug in and wait
Remount RW
passwd

ssh-keygen

Adding an additional wifi access point
--------------------------------------
wpa_supplicant.conf + /etc/network/interfaces

Installing tesla dashcam
------------------------

Setup conversion of incoming clips
----------

Installing the gallery service
------------------------------
I had to edit /var/lib/pigallery2/config/xxx to get the ports correct


Conclusion and other possible tasks
------
- wireguard VPN
- backup
