package main

import (
	"context"
	"net/http"
	"phroust/golang-api-demo/internal/queue"
)
import "github.com/aws/aws-lambda-go/lambda"
import "github.com/aws/aws-lambda-go/events"

func main() {
	lambda.Start(LambdaHandler)
}

func LambdaHandler(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	resp := events.APIGatewayProxyResponse{}

	err := queue.Publish(ctx, req.Body)
	if err != nil {
		resp.StatusCode = http.StatusInternalServerError

		return resp, err
	}

	resp.StatusCode = http.StatusAccepted

	return resp, nil
}
