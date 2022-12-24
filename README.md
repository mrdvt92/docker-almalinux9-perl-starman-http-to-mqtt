# Name

docker-centos7-perl-starman-http-to-mqtt - Docker for Starman PSGI server which publishes HTTP GET URLs to MQTT

# Docker Image

This Docker image is built from the [Official CentOS 7 Docker Image](https://hub.docker.com/_/centos).

# Starman

[Starman](https://metacpan.org/release/Starman) is a high-performance preforking [PSGI/Plack](https://metacpan.org/release/Plack) web server. We install it with `yum` from RPMs at [OpenFusion](http://repo.openfusion.net/centos7-x86_64/)

# PSGI App

The PSGI App `app.psgi` is saved inside the Docker image as `/app/app.psgi`.

# PSGI App Dependencies

Dependencies to run the PSGI app inside the container are installed in the Dockerfile. 

# Docker Build Command

```
$ sudo docker build --rm --tag=local/centos7-perl-starman-http-to-mqtt .
```

* --rm - Remove intermediate containers after a successful build.

# Docker Run Command

```
$ sudo docker run --detach --name starman --publish 5000:80 local/centos7-perl-starman-http-to-mqtt
```

* --detach - Detached mode: run the container in the background and print the new container ID. (run as -ti to see more information for debugging)
* --publish - Publish a container's port, or range of ports, to the host - [host]:[container]
