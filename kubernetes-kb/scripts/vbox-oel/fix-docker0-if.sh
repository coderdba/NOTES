ifconfig docker0 down
brctl delbr docker0
service docker reload
