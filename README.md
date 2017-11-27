[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: http://serviio.org/
[hub]: https://hub.docker.com/r/lsioarmhf/serviio/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# lsioarmhf/serviio
[![](https://images.microbadger.com/badges/version/lsioarmhf/serviio.svg)](https://microbadger.com/images/lsioarmhf/serviio "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/lsioarmhf/serviio.svg)](https://microbadger.com/images/lsioarmhf/serviio "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/lsioarmhf/serviio.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/lsioarmhf/serviio.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/armhf/armhf-serviio)](https://ci.linuxserver.io/job/Docker-Builders/job/armhf/job/armhf-serviio/)

[Serviio][appurl] is a free media server. It allows you to stream your media files (music, video or images) to renderer devices (e.g. a TV set, Bluray player, games console or mobile phone) on your connected home network.

[![serviio](https://raw.githubusercontent.com/linuxserver/community-templates/master/lsiocommunity/img/serviio-icon.png)][appurl]

## Usage

```
docker create \
--name=serviio \
-v /etc/localtime:/etc/localtime:ro \
-v <path to data>:/config \
-v <path to media>:/media \
-v <path for transcoding>:/transcode \
-e PGID=<gid> -e PUID=<uid> \
--net=host \
lsioarmhf/serviio
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `net=host` - Set network type
* `-v /etc/localtime` for timesync - *optional*
* `-v /config` - Where serviio stores its configuration files etc.
* `-v /media` - Path to your media files, add more as necessary, see below.
* `-v /transcode` - Transcode folder - see below. -*optional, but recommended*
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it serviio /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
`IMPORTANT... THIS IS THE ARMHF VERSION`

The webui is at `<your-ip>:23423/console` 

Add as many media folder mappings as required with `-v /media/tv-shows` etc... 
Setting a mapping for transcoding `-v /transcode`  ensures that the container doesn't grow unneccesarily large.

## Info

* Shell access whilst the container is running: `docker exec -it serviio /bin/bash`
* To monitor the logs of the container in realtime `docker logs -f serviio`.

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' serviio`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' lsioarmhf/sonarr`

## Versions

+ **26.11.2017:** Use cpu core counting routine to speed up build time, bump ffmpeg to 3.4 .
+ **26.08.17:** Use local copy of dcraw as dns issues on download server.
+ **30.07.17:** Bump to version 1.9 and ffmpeg to 3.3.3.
+ **30.05.16:** Rebase to alpine 3.6.
+ **17.04.16:** Initial Release.
