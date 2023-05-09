package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"os"
	"testing"
)

func TestApiGatewayV1(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/api_gateway_v1",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    "terraform-aws-lambda-api-gateway-v1",
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)
	domainName := terraform.Output(t, terraformOptions, "domain_name")

	// Test API Gateway with Lambda at the root path
	assert.NoError(t, checkHttpStatusAndBody(t, "https://"+domainName, "", "successful", http.StatusOK))

	// Test API Gateway with Lambda at /test
	assert.NoError(t, checkHttpStatusAndBody(t, "https://"+domainName+"/test", "", "successful", http.StatusOK))
}
