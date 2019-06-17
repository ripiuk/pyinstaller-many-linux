.PHONY: clean test-build docker-build docker-clear docker-rebuild

DOCKER_IMAGE_NAME=pyinstaller-many-linux

clean:
	sudo rm -rf ./build && sudo rm -rf ./dist && rm -f ./example.spec

run-example:
	./dist/example

test-build:
	$(if $(shell sudo docker images -q $(DOCKER_IMAGE_NAME)), , make docker-build)
	make clean
	sudo docker run --rm -v "${PWD}:/code" $(DOCKER_IMAGE_NAME) --onefile example.py
	make run-example

docker-build:
	sudo docker build -t $(DOCKER_IMAGE_NAME) .

docker-clear:
	sudo docker rmi -f $(DOCKER_IMAGE_NAME)

docker-rebuild: docker-clear  docker-build

docker-kill-all:
	sudo docker stop $(shell sudo docker ps -a -q)
	sudo docker rm $(shell sudo docker ps -a -q)