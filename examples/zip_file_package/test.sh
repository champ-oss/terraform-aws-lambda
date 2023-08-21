set -e

aws lambda invoke --log-type Tail --function-name $ARN output.txt > response.txt
cat response.txt
cat response.txt | jq -r .LogResult | base64 -d
cat response.txt | jq -r .StatusCode | grep 200

cat output.txt | grep successful