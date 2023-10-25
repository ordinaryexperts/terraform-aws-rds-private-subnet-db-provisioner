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

func init() {
	log.SetLevel(log.DebugLevel)
	//log.SetReportCaller(true)
}

// terraformOptions returns a populated terraform.Options object.
func terraformOptions(t *testing.T) *terraform.Options {
	// Make a copy of the terraform module to a temporary directory. This allows running multiple tests in parallel
	// against the same terraform module.
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "example")

	// Give this lambda function a unique ID for a name so we can distinguish it from any other lambdas
	// in your AWS account
	name := fmt.Sprintf("terratest-db-provisioner-%s-%s", time.Now().Format("2006-01-02"), strings.ToLower(gofakeit.Vegetable()))
	log.WithField("name", name).Info("generated name")

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, []string{"us-east-2"}, nil)
	log.WithField("region", awsRegion).Info("AWS region")

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	//terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

	return &terraform.Options{

		// The path to where our Terraform code is located
		TerraformDir: exampleFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"name":   name,
			"region": awsRegion,
		},
	}
}

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

	// Invoke the function, so we can test its output
	//response := aws.InvokeFunction(t, awsRegion, name, ExampleFunctionPayload{ShouldFail: false, Echo: "hi!"})

	// This function just echos it's input as a JSON string when `ShouldFail` is `false``
	//assert.Equal(t, `"hi!"`, string(response))

	// Invoke the function, this time causing it to error and capturing the error
	//_, err := aws.InvokeFunctionE(t, awsRegion, name, ExampleFunctionPayload{ShouldFail: true, Echo: "hi!"})

	// Function-specific errors have their own special return
	//functionError, ok := err.(*aws.FunctionError)
	//require.True(t, ok)

	// Make sure the function-specific error comes back
	//assert.Contains(t, string(functionError.Payload), "Failed to handle")
}
