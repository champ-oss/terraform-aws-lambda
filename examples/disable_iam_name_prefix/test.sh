set -e

if [[ "$ROLE_ARN" != "arn:aws:iam::912455136424:role/terraform-aws-lambda-disable-iam-name-prefix" ]]; then
    echo "role arn is not correct"
    exit 1
fi