build: build_add-item

build_add-item:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/AddItem cmd/add-item/main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/GetItem cmd/get-item/main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/RemoveItem cmd/remove-item/main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/AddMessage cmd/add-message/main.go
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -o ../out/ProcessMessage cmd/process-message/main.go


sam-build:
	cd ./infrastructure/environments/demo && sam build --hook-name terraform --skip-prepare-infra --terraform-project-root-path ../../../

# Debug calls
debug-AddItemFunction:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -gcflags="all=-N -l" -o ../out/AddItem ./cmd/add-item/...
	zip add-item ../out/AddItem
	sam local invoke 'module.main.module.lambda.aws_lambda_function.add_item' --debug-port 5858 --debugger-path ${GOPATH}/bin/ --debug-args "-delveAPI=2" --event ./events/AddItem.json

debug-GetItemFunction:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -gcflags="all=-N -l" -o ../out/GetItem ./cmd/get-item/...
	cd out && zip ../infrastructure/modules/lambda/out/get-item GetItem
	sam local invoke 'module.main.module.lambda.aws_lambda_function.get_item' --debug-port 5858 --debugger-path ${GOPATH}/bin/ --debug-args "-delveAPI=2" --event ./events/GetItem.json

debug-RemoveItemFunction:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -gcflags="all=-N -l" -o ../out/RemoveItem ./cmd/remove-item/...
	cd out && zip ../infrastructure/modules/lambda/out/remove-item RemoveItem
	sam local invoke 'module.main.module.lambda.aws_lambda_function.remove_item' --debug-port 5858 --debugger-path ${GOPATH}/bin/ --debug-args "-delveAPI=2" --event ./events/RemoveItem.json

debug-AddMessageFunction:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -gcflags="all=-N -l" -o ../out/AddMessage ./cmd/add-message/...
	cd out && zip ../infrastructure/modules/lambda/out/add-message AddMessage
	sam local invoke 'module.main.module.lambda.aws_lambda_function.add_message' --debug-port 5858 --debugger-path ${GOPATH}/bin/ --debug-args "-delveAPI=2" --event ./events/AddMessage.json

debug-ProcessMessageFunction:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -C ./src/ -gcflags="all=-N -l" -o ../out/ProcessMessage ./cmd/process-message/...
	cd out && zip ../infrastructure/modules/lambda/out/process-message ProcessMessage
	sam local invoke 'module.main.module.lambda.aws_lambda_function.process_message' --debug-port 5858 --debugger-path ${GOPATH}/bin/ --debug-args "-delveAPI=2" --event ./events/ProcessMessage.json
