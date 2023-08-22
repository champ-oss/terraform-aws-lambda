set -e

# Test API Gateway with Lambda at the root path
bash ../helper_files/http_test.sh

# Test API Gateway with Lambda at /test
export URL="$URL/test"
bash ../helper_files/http_test.sh