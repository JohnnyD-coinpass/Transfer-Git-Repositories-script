#!/bin/bash

#App Constants

yes_pattern="^([yY][eE][sS]|[yY])$"
no_pattern="^([nN][oO]|[nN])$"

# Function to validate the GitHub access token
validate_token() {
    response=$(curl -o /dev/null -s -w "%{http_code}\n" -H "Authorization: token $1" https://api.github.com/user)
    if [ "$response" -eq 200 ]; then
        echo "Token is valid."
    else
        echo "Token is invalid. Please check your access token and try again."
        exit 1
    fi
}

# Function to check if a GitHub user exists
validate_user() {
    response=$(curl -o /dev/null -s -w "%{http_code}\n" -H "Authorization: token $GITHUB_SECRET" https://api.github.com/users/$1)
    if [ "$response" -eq 200 ]; then
        echo "User $1 exists."
    else
        echo "User $1 does not exist. Please check the username and try again."
        exit 1
    fi
}

# Function to list all repositories for the authenticated user, including private repositories
list_repos() {
    echo "Listing repositories for the authenticated user:"
    curl -s -H "Authorization: token $GITHUB_SECRET" https://api.github.com/user/repos | jq -r '.[] | select(.owner.login=="'$1'") | .name'
}

# Function to transfer a repository

# set -x

git_repo_transfer() {
    echo "Requesting transfer for repository $1 from $2 to $3..."
    curl -sL -u "$2:$GITHUB_SECRET" \
	-H "Authorization: token $GITHUB_SECRET" \
	-H "Content-Type: application/json" \
	-H "Accept: application/vnd.github.v3+json" \
	-X POST https://api.github.com/repos/$2/$1/transfer \
        -d '{"new_owner":"'$3'"}' > /dev/null 

    echo "Transfer Requested for $1"
}

# Main script starts here


# Check if GITHUB_TOKEN environment variable is set 

if [ -n "$GITHUB_TOKEN" ]; then

	read -sp "Enter GitHub Access token [Enter to use stored $GITHUB_TOKEN]: " input_token
echo
    if [ -z "$input_token" ]; then
        # Use the stored token if the user input is empty
        GITHUB_SECRET=$GITHUB_TOKEN
    else
        # Use the new token provided by the user
        GITHUB_SECRET=$input_token
    fi
else
    read -sp "Enter your GitHub access token: " GITHUB_SECRET
echo
    echo "To store your token as an environment variable, add 'export GITHUB_TOKEN=your_new_token_here' to your shell profile (e.g., ~/.bash_profile, ~/.zshrc)."
fi


# Ask for Account Names

read -p "Enter your GitHub username (source account): " SOURCE_ACCOUNT
read -p "Enter the destination GitHub username: " DESTINATION_ACCOUNT

# Validate the access token and accounts
validate_token $GITHUB_SECRET
validate_user $SOURCE_ACCOUNT
validate_user $DESTINATION_ACCOUNT

# List repositories and ask the user to select
list_repos $SOURCE_ACCOUNT
echo "Enter the names of the repositories you want to transfer, separated by space ('all' to transfer all):"
read -a selected_repos

# Confirmation
echo "You have selected to transfer ${selected_repos[@]} to $DESTINATION_ACCOUNT. Are you sure? (y/n)"
read confirmation
if [ "$confirmation" =~ $no_pattern ]; then
    echo "Transfer cancelled."
    exit 0
fi

# Transfer selected repositories
if [ "${selected_repos[0]}" = "all" ]; then
    repos=$(curl -s -H "Authorization: token $GITHUB_SECRET" https://api.github.com/user/repos | jq -r '.[] | select(.owner.login=="'$SOURCE_ACCOUNT'") | .name')
else
    repos="${selected_repos[@]}"
fi


for repo in $repos; do
    git_repo_transfer "$repo" "$SOURCE_ACCOUNT" "$DESTINATION_ACCOUNT"
done
