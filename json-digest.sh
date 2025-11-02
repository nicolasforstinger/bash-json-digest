#!/bin/bash
# json-digest.sh - Extract and format JSON data from APIs

set -e

if ! command -v curl &> /dev/null; then
    echo -e "✗ curl is not installed" >&2
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo -e "✗ jq is not installed" >&2
    exit 1
fi

URL="$1"
FORMAT="${2:-simple}"

if [[ ! "$URL" =~ ^https?:// ]]; then
    echo -e "✗ Invalid URL format. Must start with http:// or https://" >&2
    exit 1
fi

echo -e "Fetching data from: ${URL}"
JSON_DATA=$(curl -s -w "\n%{http_code}" "$URL")

HTTP_CODE=$(echo "$JSON_DATA" | tail -n1)
BODY=$(echo "$JSON_DATA" | sed '$d')

if [[ "$HTTP_CODE" -ne 200 ]]; then
    echo -e "✗ HTTP $HTTP_CODE - Failed to fetch data" >&2
    exit 1
fi

if ! echo "$BODY" | jq empty 2>/dev/null; then
    echo -e "✗ Invalid JSON response" >&2
    exit 1
fi

echo -e "✓ Data retrieved successfully\n"

case "$FORMAT" in
    simple)
        echo "$BODY" | jq -r '
        if .name then "Name: \(.name)" else empty end,
        if .login then "Username: \(.login)" else empty end,
        if .company then "Company: \(.company)" else empty end,
        if .blog then "Blog: \(.blog)" else empty end,
        if .location then "Location: \(.location)" else empty end,
        if .email then "Email: \(.email)" else empty end,
        if .public_repos then "Public Repos: \(.public_repos)" else empty end,
        if .followers then "Followers: \(.followers)" else empty end
        '
        ;;
    detailed)
        echo "$BODY" | jq -r '
        "=== Profile Information ===",
        if .name then "Name: \(.name)" else empty end,
        if .login then "Username: \(.login)" else empty end,
        if .bio then "Bio: \(.bio)" else empty end,
        "",
        "=== Contact ===",
        if .company then "Company: \(.company)" else empty end,
        if .blog then "Blog: \(.blog)" else empty end,
        if .location then "Location: \(.location)" else empty end,
        if .email then "Email: \(.email)" else empty end,
        "",
        "=== Statistics ===",
        if .public_repos then "Public Repos: \(.public_repos)" else empty end,
        if .public_gists then "Public Gists: \(.public_gists)" else empty end,
        if .followers then "Followers: \(.followers)" else empty end,
        if .following then "Following: \(.following)" else empty end,
        if .created_at then "Account Created: \(.created_at)" else empty end
        '
        ;;
    raw)
        echo "$BODY" | jq '.'
        ;;
    *)
        echo -e "✗ Invalid format '$FORMAT'. Use 'simple', 'detailed', or 'raw'" >&2
        exit 1
        ;;
esac