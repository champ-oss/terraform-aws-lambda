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
	"time"
)

const (
	region            = "us-east-2"
	retryDelaySeconds = 5
	retryAttempts     = 36
)

// getAWSSession Logs in to AWS and return a session
func getAWSSession() *session.Session {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		fmt.Println(err)
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

func checkHttpStatusAndBody(t *testing.T, url, expectedBody string, expectedHttpStatus int) error {
	t.Logf("checking %s", url)

	for i := 0; ; i++ {
		resp, err := http.Get(url)
		if err != nil {
			t.Log(err)
		} else {
			t.Logf("StatusCode: %d", resp.StatusCode)
			body, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				t.Log(err)
			} else {
				t.Logf("body: %s", body)
				if resp.StatusCode == expectedHttpStatus && strings.Contains(string(body), expectedBody) {
					return nil
				}
			}
		}

		if i >= (retryAttempts - 1) {
			return fmt.Errorf("timed out while retrying")
		}

		t.Logf("Retrying in %d seconds...", retryDelaySeconds)
		time.Sleep(time.Second * retryDelaySeconds)
	}
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
