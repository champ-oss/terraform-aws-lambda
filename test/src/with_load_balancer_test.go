package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"os"
	"testing"
)

func TestWithLoadBalancer(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/with_load_balancer",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    "terraform-aws-lambda-with_load_balancer",
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	functionUrl := terraform.Output(t, terraformOptions, "function_url")

	invokeTest(t, arn)

	assert.NoError(t, checkHttpStatusAndBody(t, "https://terraform-aws-lambda.oss.champtest.net", "successful", http.StatusOK))
	assert.NoError(t, checkHttpStatusAndBody(t, functionUrl, "successful", http.StatusOK))
}
