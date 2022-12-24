IMAGE=local/centos7-perl-starman-http-to-mqtt
MQTT_HOST=mqtt.davisnetworks.com
CONTAINER=http_to_mqtt

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
