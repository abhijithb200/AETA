needed_package=(
	"hostapd"
	"dnsmasq"
	"dnsspoof"
	"apache2"
	)
installs=false
for i in "${needed_package[@]}"
do
	status="$(dpkg-query -l $i  2>&1)";
	flag="$(echo $status | grep "no packages found")";
       		
done
