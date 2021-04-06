#initialization
needed_package=(
	"hostapd"
	"dsniff"
	"dnsmasq"
	"apache2"
	)
not_installed=()


#colours
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'



echo -e "\t \t \tthis is ${RED}AETA${NC}"
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
		not_installed+=($i)		       		
	else
		echo -e "    ${GREEN}installed${NC}"
	fi
	sleep 0.5
done

if [ ${#not_installed[@]} -gt 0 ];then
	echo -e "INSTALLING THE PACKEGES"
	for i in "${not_installed[@]}"
	do
		sudo apt-get install $i;
	done
	echo "Installation Completed"
	tput reset
fi

function find_interface(){
	interface_list=();
	for i in $(ifconfig | cut -d ' ' -f1| tr ':' '\n' | awk NF)
	do
		interface_list+=("$i")
	done
	echo -e "AVAILABLE INTERFACES:"
	declare -i count=0;
	for i in "${interface_list[@]}"
	do
		echo -e "$count.  $i";
		count+=1;
	done
	echo -e "Select the interface number you want to select";
	read number
	if [ $number -gt ${#interface_list[@]} ];then
		echo -e  "${RED}ERROR${NC}";
		echo -e "The input must be in the range";
		find_interface
	else
		interface="${interface_list[$number]}"
	fi
}

find_interface;
echo "The selected interface is ${interface}"


#______________________________________________________
#making hostapd.conf
