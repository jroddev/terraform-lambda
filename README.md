## IaC for AWS Lambda using Terraform

### Manual Setup
Create an AWS S3 Bucket for tfstate backend. Use these details in main.tf backend.

---

### Setup AWS Commandline
```bash
❯ aws configure
AWS Access Key ID [None]: XXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: /XXXXXXXXXXXXXXXXXXXXXXXXXXX
Default region name [None]: ap-southeast-2
Default output format [None]:
```
---

### Terraform Create Infrastructure
```bash
# Initialize the Terraform configuration directory
# Will need to be called whenever a new module decalaration added
❯ terraform init

# Show what will change
❯ terraform plan

# Make the changes
❯ terraform apply
```

### Terraform Delete Infrastructure
This will cleanup everything created by this repository
```bash
❯ terraform destroy
```


## Create a New Lambda
Create a new directory inside of `scripts` for your project. Most will only need a single file. The directory you create will be zipped and uploaded as an AWS Lambda.

Now open `main.tf`. There are 2 blocks that you may need to duplicate.
```
module "lambda__hello_lambda" {
    source              = "./lambda"
    function_name       = "hello_lambda"
    function_directory  = "scripts/hello_lambda"
    function_handler    = "hello_lambda.lambda_handler"
    function_runtime    = "python3.8"
    iam_role            = module.iam_role.arn
}
```
This block create the actual Lambda in AWS. Update all of the `function_*` variables so that they match your new function.

If you want to be able to access the Lambda via a HTTPS request then you should also copy the 2nd block. Which may look like this:
```
module "lambda_gateway__hello_lambda" {
    source = "./lambda_api_gateway"
    api_route_path = "/hello"
    api_gateway_id = module.api_gateway.id
    api_gateway_execution_arn = module.api_gateway.execution_arn

    lambda_arn = module.lambda__hello_lambda.arn
    lambda_invoke_arn = module.lambda__hello_lambda.invoke_arn
}
```
Here you will need to update the path to use, and the `lambda_*` variables to point to your newly created lambda objection

You will need to run `terraform init` whenever you add a new `module` declaration.
Then you can run `terraform apply`. Review the changes and confirm with `yes` if they're as expected.

Once this completed you will be able to access the lambda. If the API Gateway is enabled you'll be able to curl it like this
```
curl https://<the api gateway url>/<your path>
```
The url can be found in AWS portal or built like this:
```
<lambda_integration.app_id>.execute-api.<aws region>.amazonaws.com
```
where `lambda_integration.app_id` can be seen in the terraform output



