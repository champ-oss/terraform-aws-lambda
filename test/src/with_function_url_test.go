package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestWithFunctionUrl(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/with_function_url",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")

	time.Sleep(15 * time.Minute)

	invokeTest(t, arn)

	httpTest(t, "terraform-aws-lambda-function-url.oss.champtest.net")
}
