all: push

MAJOR_VERSION = 2
MINOR_VERSION = 3
REVISION = 5

BUILD_DATE = $(shell date +"%Y%m%d")

TAG = $(MAJOR_VERSION).$(MINOR_VERSION).$(REVISION)-$(BUILD_DATE)
PREFIX = quay.io/widen/elasticsearch

build:
	docker build --pull \
		--build-arg MAJOR_VERSION=$(MAJOR_VERSION) \
		--build-arg MINOR_VERSION=$(MINOR_VERSION) \
		--build-arg REVISION=$(REVISION) \
		-t $(PREFIX):$(TAG) .

tag: build
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(MAJOR_VERSION)
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(MAJOR_VERSION).$(MINOR_VERSION)

push: tag
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(MAJOR_VERSION)
	docker push $(PREFIX):$(MAJOR_VERSION).$(MINOR_VERSION)

clean:
	docker rmi -f $(PREFIX):$(TAG) || true
	docker rmi -f $(PREFIX):$(MAJOR_VERSION) || true
	docker rmi -f $(PREFIX):$(MAJOR_VERSION).$(MINOR_VERSION) || true
