package main

import (
	"context"
	"fmt"
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

	i := database.Item{
		Body: req.Body,
	}

	id, err := database.Add(ctx, i)
	if err != nil {
		resp.StatusCode = http.StatusInternalServerError
		return resp, err
	}

	resp.StatusCode = http.StatusCreated

	resp.Headers = map[string]string{"Location": fmt.Sprintf("%s/%s", req.Path, id)}

	return resp, nil
}
