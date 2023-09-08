package queue

import (
	"context"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"os"
)

var queueURL string
var svc *sqs.SQS

func init() {
	if os.Getenv("QUEUE_URL") == "" {
		panic("env variable 'QUEUE_URL' must not be empty")
	}

	queueURL = os.Getenv("QUEUE_URL")

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	svc = sqs.New(sess)
}

func Publish(ctx context.Context, msg string) error {
	_, err := svc.SendMessageWithContext(ctx, &sqs.SendMessageInput{
		MessageBody: aws.String(msg),
		QueueUrl:    &queueURL,
	})

	return err
}
