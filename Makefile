.PHONY: help

.env:
	cp .env.dist $@

/etc/docker/daemon.json:
	cp daemon.json $@

install: .env /etc/docker/daemon.json ## Install
	echo "Edit .env !"

update: .env ## Create new certs files
	./update.sh
	echo "Restart Docker !!!"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
