for i in {1..12}; do
  curl  -H "Authorization: $AUTH_TOKEN" -H "X-API-KEY: $AUTH_TOKEN" $URL | grep successful
  result=$?
  if [[ $result -eq 0 ]]
  then
    break
  else
    sleep 5
  fi
done

if [[ $result -ne 0 ]]
then
  exit 1
fi