#!/bin/bash

# Golang installation variables
VERSION="1.7.1"
OS="linux"
ARCH="amd64"

# Home of the vagrant user, not the root which calls this script
HOMEPATH="/home/vagrant"

# Updating and installing stuff
sudo apt-get update
sudo apt-get install -y git curl

if [ ! -e "/vagrant/go.tar.gz" ]; then
	# No given go binary
	# Download golang
	FILE="go$VERSION.$OS-$ARCH.tar.gz"
	URL="https://storage.googleapis.com/golang/$FILE"

	echo "Downloading $FILE ..."
	curl --silent $URL -o "$HOMEPATH/go.tar.gz"
else
	# Go binary given
	echo "Using given binary ..."
	cp "/vagrant/go.tar.gz" "$HOMEPATH/go.tar.gz"
fi;

echo "Extracting ..."
tar -C "$HOMEPATH" -xzf "$HOMEPATH/go.tar.gz"
mv "$HOMEPATH/go" "$HOMEPATH/.go"
rm "$HOMEPATH/go.tar.gz"

# Create go folder structure
GP="/vagrant/gopath"
mkdir -p "$GP/src"
mkdir -p "$GP/pkg"
mkdir -p "$GP/bin"

# Write environment variables in the bashrc
echo "Writing environment variables ..."
touch "$HOMEPATH/.bashrc"
{
    echo '# Golang environments'
    echo 'export GOROOT=$HOME/.go'
    echo 'export PATH=$PATH:$GOROOT/bin'
    echo 'export GOPATH=/vagrant/gopath'
    echo 'export PATH=$PATH:$GOPATH/bin'

} >> "$HOMEPATH/.bashrc"