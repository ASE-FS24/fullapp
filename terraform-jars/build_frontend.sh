#!/bin/bash

# Store the current directory
CURRENT_DIR=$(pwd)

# Retrieve API endpoint URLs
# USER_API_ENDPOINT=$(aws apigatewayv2 get-apis --query "Items[?Name=='usermanager-api'].ApiEndpoint" --output text)
export USER_API_ENDPOINT=$(terraform output -raw usermanager_endpoint_url)
export POST_API_ENDPOINT=$(terraform output -raw postmanager_endpoint_url)

# Add a slash at the end of each API endpoint
# USER_API_ENDPOINT="${USER_API_ENDPOINT}/"
# POST_API_ENDPOINT="${POST_API_ENDPOINT}/"

# Output the updated API endpoints
echo "User Manager API Endpoint: ${USER_API_ENDPOINT}"
echo "Post Manager API Endpoint: ${POST_API_ENDPOINT}"

# Update .env file
sed -i "s|REACT_APP_USER_BASEURL=.*|REACT_APP_USER_BASEURL=${USER_API_ENDPOINT}|g" ../frontend/.env
sed -i "s|REACT_APP_POST_BASEURL=.*|REACT_APP_POST_BASEURL=${POST_API_ENDPOINT}|g" ../frontend/.env

# Change directory to the frontend folder
cd ../frontend || exit

# Run npm build
npm install
npm run build

# Change back to the original directory
cd "$CURRENT_DIR"

# Check if all URLs are not None
if [ ! -z "${USER_API_ENDPOINT}" ] && [ ! -z "${POST_API_ENDPOINT}" ] && [ ! -z "$(terraform output -raw frontend_url)" ] && [ ! -z "$(terraform output -raw cloudfront_url)" ]; then
  # Print success message if all URLs are not None
  echo "<-------------------------- Successfully generated all the required URLs -------------------------->"
  echo "User Manager API Endpoint: ${USER_API_ENDPOINT}"
  echo "Post Manager API Endpoint: ${POST_API_ENDPOINT}"
  echo "Front hosted S3 URL: $(terraform output -raw frontend_url)"
  echo "CloudFront URL: $(terraform output -raw cloudfront_url)"
  # terraform apply -auto-approve
  echo "<----------------- Run terraform 2 times now -- After 2 times, ignore this message -------------------->" 

else
  # Print error message if any URL is None
  echo "Error: One or more URLs are not available."
  echo "User Manager API Endpoint: ${USER_API_ENDPOINT}"
  echo "Post Manager API Endpoint: ${POST_API_ENDPOINT}"
  echo "Front hosted S3 URL: $(terraform output -raw frontend_url)"
  echo "CloudFront URL: $(terraform output -raw cloudfront_url)"
  echo "<------------------------- RUN terraform apply -auto-approve ------------------------------>"
  # terraform apply -auto-approve
fi