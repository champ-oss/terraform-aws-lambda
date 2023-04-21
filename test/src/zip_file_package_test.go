package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestZip(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir:  "../../examples/zip_file_package",
		BackendConfig: map[string]interface{}{},
		EnvVars:       map[string]string{},
		Vars:          map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	arn := terraform.Output(t, terraformOptions, "arn")
	invokeTest(t, arn)
	time.Sleep(300 * time.Second)
}
