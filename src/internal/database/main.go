package database

import (
	"context"
	"errors"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"os"
)
import "github.com/google/uuid"

var ErrItemNotFound = errors.New("item not found")

var db *dynamodb.DynamoDB
var tableName string

func init() {
	if os.Getenv("DATABASE_TABLE_NAME") == "" {
		panic("env variable 'DATABASE_TABLE_NAME' must not be empty")
	}

	tableName = os.Getenv("DATABASE_TABLE_NAME")

	// Initialize a session that the SDK will use to load
	// credentials from the shared credentials file ~/.aws/credentials
	// and region from the shared configuration file ~/.aws/config.
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))

	// Create DynamoDB client
	db = dynamodb.New(sess)
}

func Add(ctx context.Context, i Item) (string, error) {

	i.ID = uuid.New().String()

	av, err := dynamodbattribute.MarshalMap(i)
	if err != nil {
		return "", err
	}

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(tableName),
	}

	_, err = db.PutItemWithContext(ctx, input)
	if err != nil {
		return "", err
	}

	return i.ID, nil
}

func Remove(ctx context.Context, ID string) error {

	input := &dynamodb.DeleteItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"ID": {
				S: aws.String(ID),
			},
		},
		TableName: aws.String(tableName),
	}

	_, err := db.DeleteItemWithContext(ctx, input)

	return err
}

func Get(ctx context.Context, ID string) (Item, error) {
	i := Item{}

	result, err := db.GetItemWithContext(ctx, &dynamodb.GetItemInput{
		TableName: aws.String(tableName),
		Key: map[string]*dynamodb.AttributeValue{
			"ID": {
				S: aws.String(ID),
			},
		},
	})

	if err != nil {
		return i, err
	}

	if result.Item == nil {
		return i, ErrItemNotFound
	}

	err = dynamodbattribute.UnmarshalMap(result.Item, &i)

	return i, err
}
