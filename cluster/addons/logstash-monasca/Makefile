.PHONY:	build push

IMAGE = logstash-monasca
TAG = 1.0

build:
	docker build -t taimir93/$(NAME) .

push:
	docker push taimir93/$(NAME):$(TAG)
