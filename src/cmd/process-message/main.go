package main

import (
	"context"
	"errors"
	"log"
	"math/rand"
	"time"
)
import "github.com/aws/aws-lambda-go/lambda"
import "github.com/aws/aws-lambda-go/events"

var r *rand.Rand

func init() {
	// initialize a source to generate random numbers
	s := rand.NewSource(time.Now().UnixNano())
	r = rand.New(s)
}

func main() {
	lambda.Start(LambdaHandler)
}

func LambdaHandler(ctx context.Context, req events.SQSEvent) (events.SQSEventResponse, error) {

	res := events.SQSEventResponse{}

	for _, rec := range req.Records {
		err := processMessage(ctx, rec)
		if err != nil {
			res.BatchItemFailures = append(res.BatchItemFailures, events.SQSBatchItemFailure{ItemIdentifier: rec.MessageId})
			continue
		}
	}

	return res, nil
}

func processMessage(ctx context.Context, m events.SQSMessage) error {
	log.Printf("Processing message: %s\n", m.MessageId)

	if r.Intn(5) == 1 {
		log.Println("Forcing random failure to demonstrate BatchItemFailure")

		return errors.New("a wild error appears")
	}

	log.Printf("Message: %s\n", m.Body)

	return nil
}
