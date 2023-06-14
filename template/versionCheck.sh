#!/bin/bash
VERSION='1.0.1'
# Don't remove the above line. Serves as the version this script will fetch. Only update when a new version is out.

ERROR='\033[1;31m[*] Error:\033[1;37m '
SUCCESS='\033[1;32m==>\033[1;37m '

# Check if user has both commands curl and sed, if not tell them to install them for this functionality
if ! [ -x "$(command -v curl)" ]; then
	echo -e "${ERROR}You must install curl for the version check to work"
	exit 0 # Exit 0 since this is not critical. (Allows compilation to continue)
fi

if ! [ -x "$(command -v sed)" ]; then
	echo -e "${ERROR}You must install sed for the version check to work"
	exit 0 # Exit 0 since this is not critical. (Allows compilation to continue)
fi

# Check if GitHub is reachable
curl -s https://github.com > /dev/null
githubReachable=$?

if ! [ $githubReachable == 0  ]; then
	exit 0
fi

if ! [ $(curl -Ls https://github.com/joeyjurjens/iOS-Mod-Menu-Template-for-Theos/raw/master/template/versionCheck.sh | sed -n 2p) = "VERSION='$VERSION'"  ]; then
	echo -e "${SUCCESS}A newer version of the template is available!"
fi
