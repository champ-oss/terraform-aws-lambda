package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"os/exec"
	"testing"
	"time"
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
	terraform.Init(t, terraformOptions)

	// recursively set prevent destroy to false
	cmd := exec.Command("bash", "-c", "find . -type f -name '*.tf' -exec sed -i'' -e 's/prevent_destroy = true/prevent_destroy = false/g' {} +")
	cmd.Dir = "../../"
	_ = cmd.Run()

	defer deleteRepo(getAWSSession(), "terraform-aws-lambda/docker-hub")

	terraform.ApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	time.Sleep(300 * time.Second)
	invokeTest(t, arn)
}
