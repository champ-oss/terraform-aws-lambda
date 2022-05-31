package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestDockerHubImage(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/docker_hub_image",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars: map[string]interface{}{
			"ecr_tag": os.Getenv("GITHUB_SHA"),
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	invokeTest(t, arn)
}
