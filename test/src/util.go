package test

import (
	"encoding/base64"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go/service/ecr"
	"github.com/aws/aws-sdk-go/service/lambda"
	"github.com/stretchr/testify/assert"
	"io/ioutil"
	"net/http"
	"strings"
	"testing"
)

var region = "us-east-1"

// getAWSSession Logs in to AWS and return a session
func getAWSSession() *session.Session {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}
	return sess
}

func invokeTest(t *testing.T, functionArn string) {
	sess := getAWSSession()
	svc := lambda.New(sess, aws.NewConfig().WithRegion(region))

	t.Log("Invoking function:", functionArn)
	output, err := svc.Invoke(&lambda.InvokeInput{
		FunctionName: aws.String(functionArn),
		LogType:      aws.String("Tail"),
	})
	assert.NoError(t, err)

	t.Log("status code:", *output.StatusCode)
	assert.Equal(t, int64(200), *output.StatusCode)

	t.Log("output result:", string(output.Payload))
	assert.True(t, strings.Contains(string(output.Payload), "successful"))

	logs, _ := base64.StdEncoding.DecodeString(*output.LogResult)
	t.Log("logs:", string(logs))
	assert.True(t, strings.Contains(string(logs), "successful"))
}

func httpTest(t *testing.T, url string) {
	t.Log("Calling http url:", url)
	resp, err := http.Get(url)
	assert.NoError(t, err)

	t.Log("status code:", resp.StatusCode)
	assert.Equal(t, 200, resp.StatusCode)

	body, err := ioutil.ReadAll(resp.Body)
	assert.NoError(t, err)
	t.Log("http response body:", string(body))
	assert.True(t, strings.Contains(string(body), "successful"))
}

func GetLogs(session *session.Session, region string, logGroup string, logStream *string) []*cloudwatchlogs.OutputLogEvent {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.GetLogEventsInput{
		LogGroupName:  aws.String(logGroup),
		LogStreamName: aws.String(*logStream),
	}
	resp, _ := svc.GetLogEvents(params)

	// Pretty-print the response data.
	fmt.Println(resp)
	return resp.Events
}

func GetLogStream(session *session.Session, region string, logGroup string) *string {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(logGroup),
		Descending:   aws.Bool(true),
		OrderBy:      aws.String("LastEventTime"),
	}

	resp, _ := svc.DescribeLogStreams(params)

	stream := resp.LogStreams[0].LogStreamName

	// Pretty-print the response data.
	fmt.Println(resp)
	return stream
}

// deleteRepo deletes an AWS ECR repo
func deleteRepo(session *session.Session, repo string) {
	svc := ecr.New(session, aws.NewConfig().WithRegion(region))

	result, err := svc.DeleteRepository(&ecr.DeleteRepositoryInput{
		Force:          aws.Bool(true),
		RepositoryName: &repo,
	})
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(result)
	fmt.Println("Repo deleted")
}
