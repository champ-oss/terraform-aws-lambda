package test

import (
	"context"
	"fmt"
	"github.com/Nerzal/gocloak/v13"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"net/http"
	"os"
	"testing"
)

func TestWithApiGateway(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/with_api_gateway",
		BackendConfig: map[string]interface{}{
			"bucket": os.Getenv("TF_STATE_BUCKET"),
			"key":    "terraform-aws-lambda-with_api_gateway",
		},
		EnvVars: map[string]string{},
		Vars:    map[string]interface{}{},
	}
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	keycloakPassword := terraform.Output(t, terraformOptions, "keycloak_admin_password")
	keycloakEndpoint := terraform.Output(t, terraformOptions, "keycloak_endpoint")

	jwt := getKeycloakJwt(keycloakEndpoint, "master", "admin", keycloakPassword)
	assert.NoError(t, checkHttpStatusAndBody(t, "https://terraform-aws-lambda-apigw.oss.champtest.net", jwt, "successful", http.StatusOK))
}

func getKeycloakJwt(basePath, realm, username, password string) string {
	fmt.Println("getting JWT from:", basePath)
	client := gocloak.NewClient(basePath)
	jwt, err := client.LoginAdmin(context.TODO(), username, password, realm)
	if err != nil {
		fmt.Println(err)
		return ""
	}
	return jwt.AccessToken
}
