package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"
)

func TestWithCloudwatchEvent(t *testing.T) {
	t.Parallel()

	region := "us-east-1"

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/with_cw_event",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	// Calling Sleep method
	time.Sleep(60 * time.Second)

	logger.Log(t, "Creating AWS Session")
	sess := getAWSSession()

	// get lambda tf output logGroupName
	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "cloudwatch_log_group")

	actualLogStreamName := GetLogStream(sess, region, cloudwatchLogGroup)
	fmt.Print(actualLogStreamName)

	logger.Log(t, "getting logs")
	outputLogs := GetLogs(sess, region, cloudwatchLogGroup, actualLogStreamName)

	logger.Log(t, "checking message in log stream for expected value")
	expectedResponse := "successful"
	assert.Contains(t, expectedResponse, *outputLogs[3].Message)
}
