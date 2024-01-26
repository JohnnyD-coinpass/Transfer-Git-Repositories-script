# GitHub Repository Transfer Script

Welcome to the GitHub Repository Transfer Script! This script is designed to facilitate the transfer of one, many, or all of your GitHub repositories to another user account seamlessly. It's open and available for anyone who needs to manage repository transfers efficiently.

## Features
- Transfer a single repository, multiple repositories, or all repositories from one GitHub account to another.
- Validate GitHub access tokens and user existence before initiating transfers.
- List all repositories for the authenticated user, including private ones.

## Prerequisites
Before you get started, ensure you have the following installed:
- **bash**: The script is a bash script and requires a Unix-like environment to run.
- **curl**: Used for making API requests to GitHub.
- **jq**: A lightweight and flexible command-line JSON processor, used for parsing JSON responses.

### Installing Dependencies
- **curl**: Usually pre-installed in most Unix-like operating systems. If not, you can install it using your package manager. For example, on Ubuntu, you can use `sudo apt-get install curl`.
- **jq**: Install using your package manager. For example, on Ubuntu, use `sudo apt-get install jq`.

## Installation
1. Clone this repository or download the script directly to your local machine.
2. Ensure the script is executable by running the command `chmod +x path/to/transfer_git_repos.sh`.

## Usage
To use the script, follow these steps:

1. Open your terminal.
2. Navigate to the directory where the script is located.
3. Execute the script by running `./transfer_git_repos.sh`.
4. When prompted, enter your GitHub access token. You can generate a new token from [GitHub Developer Settings](https://github.com/settings/tokens). Make sure it has the `repo` and `delete_repo` scopes if you wish to transfer private repositories or delete repositories.
5. Follow the on-screen instructions to enter the source GitHub username (from which the repositories will be transferred) and the destination GitHub username (to which the repositories will be transferred).
6. The script will then list all the repositories available for transfer under the source account. Enter the names of the repositories you wish to transfer, separated by space. Type `all` to transfer all repositories.
7. Confirm your selection when prompted.

## Security Note
- Always keep your GitHub access token secure.
- Do not share your access token or include it in version-controlled files.

## Contribution
Contributions are welcome! If you have improvements or bug fixes, feel free to fork the repository and submit a pull request.

## License
This script is open-sourced under the MIT License. Feel free to use it, modify it, and distribute it as you see fit.

## Support
If you encounter any issues or have questions, please file an issue in the repository. 

Enjoy automating your GitHub repository transfers!
