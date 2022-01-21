#!/bin/sh

instance="https://fosstodon.org"
access_token=""

# random display name
# Display name should never exceed Mastodon's 30 character limit
display_name=$(printf "ClosedGL the "; shuf -n 1 titles)
echo $display_name
if [ $(echo $display_name | wc -m) -gt "31" ];then
	echo "Name is longer than 30 characters and cannot be set." > /dev/stderr
	exit 1
fi

# change display name
curl -X PATCH \
	-H "Authorization: Bearer $access_token" \
	-d "display_name=$display_name" \
	$instance"/api/v1/accounts/update_credentials" >& /dev/null