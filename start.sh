if [ -z $1 ] 
then
	echo "Error: You must use \`start\` or \`stop\` when running this script!"
	exit -1
fi

if [ $1 == "start" ] 
then
	if [[ $(ps aux | grep "jekyll serve" | wc -l) > 1 ]]
	then
		echo "Error: Server is already running"
		exit -1
	fi

	echo "Starting the server . . ."
	bundle exec jekyll serve --incremental &
	exit 1
fi

if [ $1 == "stop" ]
then
	PID=$( ps aux | grep "jekyll serve" | head -1 | head -c 14 | tail -c 4 )
	kill $PID
	echo "Process successfully terminated."
	exit 1
fi

echo "Error: Invalid parameter 1 input, please use either \`start\` or \`stop\`!"
exit -1
