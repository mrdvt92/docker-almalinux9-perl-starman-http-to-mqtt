NAME=perl-starman-http-to-mqtt
SPEC=$(NAME).spec
VERSION = $(shell sed -e '/Version:/!d' -e 's/[^0-9.]*\([0-9.]*\).*/\1/' $(SPEC))
DISTDIR = $(NAME)-$(VERSION)
IMAGE=local/centos7-$(NAME)
MQTT_HOST=mqtt.davisnetworks.com
CONTAINER=http_to_mqtt
SRCS=app.psgi perl-starman-http-to-mqtt.service
AUX=$(SPEC) LICENSE

all:
	@echo "Syntax:"
	@echo "  make build   # builds the docker image from the Dockerfile as $(IMAGE)"
	@echo "  make run     # runs the docker image on http://127.0.0.1:5000/"
	@echo "  make rm      # stops and removes the image"
	@echo "  make bash    # executes a bash shell on the running container"

build:	Dockerfile app.psgi
	docker build --rm --tag=$(IMAGE) .

run:
	docker run --detach --env MQTT_HOST=$(MQTT_HOST) --name $(CONTAINER) --publish 5000:80 $(IMAGE)

rm:	
	docker stop $(CONTAINER)
	docker rm $(CONTAINER)

bash:
	docker exec -it $(CONTAINER) /bin/bash

dist:	$(SRCS) $(AUX)
	@echo "Prepare"
	-rm -rf $(DISTDIR)
	@echo "Creating folder $(DISTDIR)"
	mkdir $(DISTDIR)
	@echo "Hardlinking files for tarball"
	ln $(SRCS) $(AUX) $(DISTDIR)
	@echo "Creating tarball $(DISTDIR).tar.gz"
	tar chzfv $(DISTDIR).tar.gz $(DISTDIR)
	@echo "Cleaning up..."
	-rm -rf $(DISTDIR)
	@echo "Finished!"

$(DISTDIR).tar.gz:	dist

rpm:	$(DISTDIR).tar.gz
	rpmbuild -ta $(DISTDIR).tar.gz
