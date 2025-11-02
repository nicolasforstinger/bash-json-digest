# JSON Digest

A bash script for automated API data extraction and formatted reporting.

## Features
- Fetches JSON data from any REST API endpoint
- Multiple output formats
- Error handling
- Human-readable output
- Dependency checking for required tools

## Prerequisites
- `curl` - for fetching data from URLs
- `jq` - for JSON parsing and formatting

## Usage
```bash
./json-digest.sh url format
```

**Arguments:**
- `url` - API endpoint URL to fetch JSON data from
- `format` - Output format: `simple` (default), `detailed`, or `raw`

## Examples

```bash
# Get GitHub user profile in simple format
./json-digest.sh https://api.github.com/users/nicolasforstinger

# Get detailed profile information
./json-digest.sh https://api.github.com/users/torvalds detailed

# Get raw JSON output for further processing
./json-digest.sh https://api.github.com/users/github raw

# Fetch repository information
./json-digest.sh https://api.github.com/repos/torvalds/linux

# Fetch public API data
./json-digest.sh https://jsonplaceholder.typicode.com/users/1
```