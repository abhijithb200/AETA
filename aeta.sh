needed_package=(
	"hostapd"
	"dnsmasq"
	"dnsspoof"
	"apache2"
	)
installs=false

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
echo -e "this is ${RED}AETA${NC}"
echo -e
echo -e

echo "The packages in use:"
for f in "${needed_package[@]}"
do
	echo $f
	
done
echo -e
echo -e
echo -e

for i in "${needed_package[@]}"
do
	echo -ne "   $i"
	status="$(dpkg-query -l $i  2>&1)";
	flag="$(echo $status | grep "no packages found")";
	if [[ `echo $status | grep "no packages found"` ]];then
		echo -e  "   ${RED}not installed${NC}"		       		
	else
		echo -e "    ${GREEN}installed${NC}"
	fi
	sleep 3
done
