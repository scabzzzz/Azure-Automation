#set NTP servers, restart service and resync
w32tm /config /manualpeerlist:'time.nist.gov pool.ntp.org' /syncfromflags:manual /reliable:yes /update
restart-service w32time
w32tm /resync