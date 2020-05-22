push:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t skandragon/postgresql-simple-backup:latest . --push

build:
	docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t skandragon/postgresql-simple-backup:latest .
