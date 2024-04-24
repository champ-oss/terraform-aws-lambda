set -e

echo $FUNCTION_NAME | grep "terraform-aws-lambda-disable-iam-name-prefix"
echo $ROLE_ARN | grep "role/terraform-aws-lambda-disable-iam-name-prefix"