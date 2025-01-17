
all: clean build run

build:
	./build-or-push.sh build

clean:
	podman rm -fa
	rm -f *.ov *.log

run:
	podman network create --subnet 10.89.0.0/24 --gateway 10.89.0.1 myCNI || true
	podman run -dt --network myCNI --ip 10.89.0.2 --name owner-onboarding-service quay.io/ayosef/fdo-owner-onboarding-service
	podman run -dt --network myCNI --ip 10.89.0.3 --name rendezvous-server quay.io/ayosef/fdo-rendezvous-server
	podman run -dt --network myCNI --ip 10.89.0.4 --name owner quay.io/ayosef/fdo-base /bin/bash

push:
	./build-or-push.sh push

build-n-push: build push

poc: all
	./poc.sh
