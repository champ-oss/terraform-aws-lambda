set -e
if [ "$ENABLED" = "true" ]; then
  echo -e "\nInvoking the Lambda function..."
  aws lambda invoke --log-type Tail --function-name $ARN output.txt > response.txt

  echo -e "\nLambda response:"
  cat response.txt

  echo -e "\nChecking log result:"
  cat response.txt | jq -r .LogResult | base64 -d | grep successful

  echo -e "\nChecking status code:"
  cat response.txt | jq -r .StatusCode | grep 200

  echo -e "\nChecking lambda output:"
  cat output.txt | grep successful
else
  echo "Module is disabled, no resources created"
fi
