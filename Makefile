.PHONY: build run

build:
	docker build -t paolomainardi/release-it -f build/Dockerfile .

dev:
	@chmod +x build/docker-entrypoint.sh
	@source tests/common.sh && run

run:
	docker run -it --rm -v $(PWD):/app paolomainardi/release-it