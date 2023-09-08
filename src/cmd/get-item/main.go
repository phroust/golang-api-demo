package main

import (
	"context"
	"net/http"
	"phroust/golang-api-demo/internal/database"
)
import "github.com/aws/aws-lambda-go/lambda"
import "github.com/aws/aws-lambda-go/events"

func main() {
	lambda.Start(LambdaHandler)
}

func LambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	resp := events.APIGatewayProxyResponse{}

	item, err := database.Get(ctx, req.PathParameters["itemID"])
	if err == database.ErrItemNotFound {
		resp.StatusCode = http.StatusNotFound
		return resp, nil
	} else if err != nil {
		resp.StatusCode = http.StatusInternalServerError
		return resp, err
	}

	resp.StatusCode = http.StatusOK
	resp.Body = item.Body

	return resp, nil
}
