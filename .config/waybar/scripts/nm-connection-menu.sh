nm_pid=$(pgrep nm-connection)

if [ $nm_pid ]; then 
	{ kill $nm_pid && wait $nm_pid; } 2>/dev/null
else 
	nm-connection-editor
fi
