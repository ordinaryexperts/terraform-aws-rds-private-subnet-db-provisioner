package test

import (
	"fmt"
	"github.com/brianvoe/gofakeit/v6"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	log "github.com/sirupsen/logrus"
)

type ExampleFunctionPayload struct {
	Echo       string
	ShouldFail bool
}

type testConfiguration struct {
	name   string
	opts   *terraform.Options
	region string
}

var name = fmt.Sprintf("terratest-db-provisioner-%s-%s", time.Now().Format("2006-01-02"), strings.ToLower(gofakeit.Vegetable()))
var availableRegions = []string{"us-east-2", "us-west-2"}

func init() {
	log.SetLevel(log.DebugLevel)
	//log.SetReportCaller(true)

	log.WithFields(log.Fields{
		"log_level": log.GetLevel(),
		"name":      name,
	}).Info("Configuration")

}

// terraformOptions returns a populated terraform.Options object.
func terraformOptions(t *testing.T) *terraform.Options {
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "example")
	region := aws.GetRandomStableRegion(t, availableRegions, nil)
	return &terraform.Options{
		TerraformDir: exampleFolder,
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":   name,
			"region": region,
		},
	}
}

// TestValidate checks that our Terraform code is valid.
func TestValidate(t *testing.T) {
	opts := terraformOptions(t)

	terraform.Init(t, opts)
	terraform.Validate(t, &terraform.Options{
		// Cannot pass non-empty Options.Vars to Validate
		TerraformDir: opts.TerraformDir,
	})
}

func TestDeployOnly(t *testing.T) {
	t.Parallel()

	opts := terraformOptions(t)

	terraform.Init(t, opts)

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, opts)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, opts)

	aws.GetRdsInstanceDetailsE(t, name, region)
	// Invoke the function, so we can test its output
	//response := aws.InvokeFunction(t, region, name, ExampleFunctionPayload{ShouldFail: false, Echo: "hi!"})

	// This function just echos it's input as a JSON string when `ShouldFail` is `false``
	//assert.Equal(t, `"hi!"`, string(response))

	// Invoke the function, this time causing it to error and capturing the error
	//_, err := aws.InvokeFunctionE(t, region, name, ExampleFunctionPayload{ShouldFail: true, Echo: "hi!"})

	// Function-specific errors have their own special return
	//functionError, ok := err.(*aws.FunctionError)
	//require.True(t, ok)

	// Make sure the function-specific error comes back
	//assert.Contains(t, string(functionError.Payload), "Failed to handle")
}
