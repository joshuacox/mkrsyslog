.PHONY: all help build run builddocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   3. make logs      - follow the logs of docker container

build: NAME TAG PORT builddocker

# run a plain container
run: NAME TAG PORT build rsyslogCID

rsyslog: run

rsyslogCID:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval PORT := $(shell cat PORT))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="rsyslogCID" \
	-v $(TMP):/tmp \
	-d \
	-p $PORT:$PORT \
	-v "`pwd`/rsyslog.conf":/etc/rsyslog.conf \
	-t $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat rsyslogCID`

rm-image:
	-@docker rm `cat rsyslogCID`
	-@rm rsyslogCID

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat rsyslogCID` /bin/bash

logs:
	docker logs -f `cat rsyslogCID`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

PORT:
	@while [ -z "$$PORT" ]; do \
		read -r -p "Enter the port you wish to associate with this container [PORT]: " PORT; echo "$$PORT">>PORT; cat PORT; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;

rmall: rm  rmmysql

example:
	cp -i rsyslog.conf.example rsyslog.conf
