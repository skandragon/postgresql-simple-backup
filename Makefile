push:
	docker buildx build --pull --platform linux/amd64,linux/arm64 -t skandragon/postgresql-simple-backup:latest . --push

build:
	docker buildx build --pull --platform linux/amd64,linux/arm64 -t skandragon/postgresql-simple-backup:latest .
