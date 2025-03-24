# Name

docker-almalinux9-perl-starman-http-to-mqtt - Docker for Starman PSGI server which publishes HTTP GET URLs to MQTT

# Docker Image

This Docker image was built based on the [Almalinux Container image for Ansible Testing](https://github.com/bpadair32/docker-image-alma9-systemd)

# Starman

[Starman](https://metacpan.org/release/Starman) is a high-performance preforking [PSGI/Plack](https://metacpan.org/release/Plack) web server. We install it with `yum` from RPMs at [DavisNetwokrs](https://linux.davisnetworks.com/el9/updates/)

# PSGI App

The PSGI App `app.psgi` is saved inside the Docker image as `/app/app.psgi`.

# PSGI App Dependencies

Dependencies to run the PSGI app inside the container are installed in the Dockerfile. 

# Docker Build Command

```
$ sudo docker build --rm --tag=local/almalinux9-perl-starman-http-to-mqtt .
```

* --rm - Remove intermediate containers after a successful build.

# Docker Run Command

```
$ sudo docker run --detach --name http_to_mqtt --publish 5000:80 local/almalinux9-perl-starman-http-to-mqtt
```

* --detach - Detached mode: run the container in the background and print the new container ID. (run as -ti to see more information for debugging)
* --publish - Publish a container's port, or range of ports, to the host - [host]:[container]

# See Also

  - HTTP to MQTT bridge - [Nodejs](https://github.com/petkov/http_to_mqtt) - [Docker](https://hub.docker.com/r/migoller/http-mqtt-bridge) - [Docker Source](https://github.com/MiGoller/docker-http-mqtt-bridge)
