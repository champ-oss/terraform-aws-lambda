aws lambda invoke --log-type Tail --function-name $FUNCTION_NAME output.txt
cat output.txt