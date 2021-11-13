if [ -z $1 ] 
then
	echo "Error: You must use \`start\`, \`stop\`, or \`restart\` when running this script!"
	exit -1
fi

process_count=$(ps aux | grep "jekyll serve" | wc -l) 

if [[ $process_count > 1 ]] 
then
	is_running=1
else
	is_running=0
fi

if [ $1 == "start" ] 
then
	if [[ $is_running == "1" ]]
	then
		echo "Error: Server is already running"
		exit -1
	fi

	echo "Starting the server . . ."
	bundle exec jekyll serve --incremental &
	exit 1
fi

if [ $1 == "restart" ]
then
	if [[ $is_running == 1 ]]
	then
		PID=$( ps aux | grep "jekyll serve" | head -1 | head -c 14 | tail -c 4 )
		kill $PID
	fi
	bundle exec jekyll serve --incremental &
	echo "Restarting the server. . . "
	exit 1
fi



if [ $1 == "stop" ]
then
	if [[ $is_running == 0 ]]
	then
		echo "Error: Process is not running"
		exit -1
	fi
	PID=$( ps aux | grep "jekyll serve" | head -1 | head -c 14 | tail -c 4 )
	kill $PID
	echo "Process successfully terminated."
	exit 1
fi

echo "Error: Invalid parameter 1 input, please use either \`start\`, \`stop\`, or \`restart\`!"
exit -1
