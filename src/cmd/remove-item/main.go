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

	id := req.PathParameters["itemID"]
	if id == "" {
		resp.StatusCode = http.StatusBadRequest
		return resp, nil
	}

	err := database.Remove(ctx, id)
	if err != nil {
		resp.StatusCode = http.StatusInternalServerError

		return resp, err
	}

	resp.StatusCode = http.StatusNoContent

	return resp, nil
}
