package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestWithLoadBalancer(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/with_load_balancer",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars: map[string]interface{}{
			"ecr_tag": os.Getenv("PULL_REQUEST_HEAD_SHA"),
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	invokeTest(t, arn)

	httpTest(t, "terraform-aws-lambda.oss.champtest.net")
}
