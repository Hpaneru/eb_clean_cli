#
# Copyright (c) 2022.
# Author: Kishor Mainali
# Company: EB Pearls
#
#

# This script creates/updates credentials.json file which is used
# to authorize publishers when publishing packages to pub.dev.

# Checking whether the secrets are available as environment variables.

if [ -z "${PUB_DEV_PUBLISH_ACCESS_TOKEN}" ]; then
  echo "PUB_DEV_PUBLISH_ACCESS_TOKEN is not set."
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_REFRESH_TOKEN}" ]; then
  echo "PUB_DEV_PUBLISH_REFRESH_TOKEN is not set."
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" ]; then
  echo "PUB_DEV_PUBLISH_TOKEN_ENDPOINT is not set."
  exit 1
fi

if [ -z "${PUB_DEV_PUBLISH_EXPIRATION}" ]; then
  echo "PUB_DEV_PUBLISH_EXPIRATION is not set."
  exit 1
fi

# Create credentials.json file.

cat <<EOF >~/.pub-credentials.json
{
  "accessToken": "${PUB_DEV_PUBLISH_ACCESS_TOKEN}",
  "refreshToken": "${PUB_DEV_PUBLISH_REFRESH_TOKEN}",
  "tokenEndpoint": "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}",
   "scopes": [
      "openid",
      "https://www.googleapis.com/auth/userinfo.email"
    ],
  "expiration": "${PUB_DEV_PUBLISH_EXPIRATION}"
}
EOF
