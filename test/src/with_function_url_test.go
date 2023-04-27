package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"os"
	"testing"
)

func TestWithFunctionUrl(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/with_function_url",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    "terraform-aws-lambda-with_function_url",
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	functionUrl := terraform.Output(t, terraformOptions, "function_url")

	invokeTest(t, arn)

	assert.NoError(t, checkHttpStatusAndBody(t, functionUrl, "", "successful", http.StatusOK))
}
