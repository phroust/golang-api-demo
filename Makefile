build: build_add-item

build_add-item:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/AddItem cmd/add-item/main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/GetItem cmd/get-item/main.go

