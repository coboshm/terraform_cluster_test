dependencies:
	go get -t ./...

build: dependencies
	mkdir -p build
	#GOOS=linux GOARCH=amd64 go build -o build/api
	go build -o build/api

orchestrate: build
	terraform apply terraform/