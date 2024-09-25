#!/bin/bash

# Ensure GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI is not installed. Please install it first."
    exit 1
fi

# Check if GitHub CLI is authenticated
if ! gh auth status &> /dev/null; then
    echo "GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
fi

# Set the repository
repo="christitustech/linutil"

# Fetch a larger number of PRs (e.g., 1000)
prs=$(gh pr list --repo "$repo" --state open --json number --limit 1000 --jq '.[].number')

# Message to post
message="Sorry for the inconvenience. We had a massive restructure of the codebase to improve future development. Because of this, can you update your PR to the new structure? Thank you for your assistance and contribution."

# Loop through each PR and post the message
for pr in $prs; do
    if [ "$pr" -le 258 ]; then
        echo "Posting message to PR #$pr"
        gh pr comment "$pr" --repo "$repo" --body "$message"
    else
        echo "Skipping PR #$pr as it's above 258"
    fi
done

echo "Messages posted to all open PRs up to #258 in $repo"
