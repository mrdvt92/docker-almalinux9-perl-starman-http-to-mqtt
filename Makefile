IMAGE=local/centos7-perl-starman-http-to-mqtt
MQTT_HOST=mqtt.davisnetworks.com

all:
	@echo "Syntax:"
	@echo "  make build   # builds the docker image from the Dockerfile as $(IMAGE)"
	@echo "  make run     # runs the docker image $(IMAGE) as starman on http://127.0.0.1:5000/"
	@echo "  make rm      # stops and removes the image starman"
	@echo "  make bash    # executes a bash shell on the running starman container"

build:	Dockerfile app.psgi
	docker build --rm --tag=$(IMAGE) .

run:
	docker run --detach --env MQTT_HOST=$(MQTT_HOST) --name starman --publish 5000:80 $(IMAGE)

rm:	
	docker stop starman
	docker rm starman

bash:
	docker exec -it starman /bin/bash
