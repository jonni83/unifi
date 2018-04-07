#!/bin/biash

# Run the Unifi Container
function unifi-remove () {
	sudo docker rm unifi
}	

# Run the Unifi Container
function unifi-start () {
	sudo docker start unifi &
}	

# Stop the Unifi Container
function unifi-stop () {
	sudo docker stop unifi
}

# Create/Run the Unifi Container
function unifi-run () {
	sudo docker run --detach --restart always --network="host" --init \
		-p 8080:8080 -p 8443:8443 -p 3478:3478/udp -p 10001:10001/udp \
		-e RUNAS_UID0=false -v ~/unifi:/unifi --name unifi \
		jacobalberty/unifi:latest
}	

# Update and run the container 
function unifi-update () {
	echo "Checking for newer image"
	NEW_IMAGE=false
	if sudo docker pull jacobalberty/unifi:latest | \
		grep -q "Downloaded newer image"; then
		echo "Downloaded newer image"
		NEW_IMAGE=true
	else
		echo "Image is up to date"
	fi
	# Deal with a running container
	if sudo docker ps | grep -q "jacobalberty/unifi"; then
		echo "Container is running"
		if [ ${NEW_IMAGE} = true ]; then
			echo "Stopping container"
			unifi-stop
		else
			return 0
		fi
	fi
	# Container is not running
	if [ ${NEW_IMAGE} = true ]; then
		echo "Removing old container"
		unifi-remove
	fi
	# New or not, it's time to run!
	echo "Creating and running container"
	unifi-run
}
