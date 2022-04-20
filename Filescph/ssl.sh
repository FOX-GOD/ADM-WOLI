#!/bin/bash

clear
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
SCPdir="/etc/newadm"
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit

sshports=`netstat -tunlp | grep sshd | grep 0.0.0.0: | awk '{print substr($4,9); }' > /tmp/ssh.txt && echo | cat /tmp/ssh.txt | tr '\n' ' ' > /etc/newadm/sshports.txt && cat /etc/newadm/sshports.txt`;

mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
}

colores
lor1='\033[1;31m';lor2='\033[1;32m';lor3='\033[1;33m';lor4='\033[1;34m';lor5='\033[1;35m';lor6='\033[1;36m';lor7='\033[1;37m'

if [ $(id -u) -eq 0 ];then
clear
else
echo -e "Run the script as user${lor2}root${lor7}"
exit
fi 

#espe () {   
#echo -e "${lor7}"
#read -p " Enter to Continue.."
#}

fun_bar () {
          comando[0]="$1"
          comando[1]="$2"
          (
          [[ -e $HOME/fim ]] && rm $HOME/fim
          ${comando[0]} > /dev/null 2>&1
          ${comando[1]} > /dev/null 2>&1
          touch $HOME/fim
          ) > /dev/null 2>&1 &
          tput civis
		  echo -e "${lor7}---------------------------------------------------${lor7}"
          echo -ne "${lor7}    WAIT..${lor1}["
          while true; do
          for((i=0; i<18; i++)); do
          echo -ne "${lor5}#"
          sleep 0.2s
          done
         [[ -e $HOME/fim ]] && rm $HOME/fim && break
         echo -e "${col5}"
         sleep 1s
         tput cuu1
         tput dl1
         echo -ne "${lor7}    WAIT..${lor1}["
         done
         echo -e "${lor1}]${lor7} -${lor7} FINISHED ${lor7}"
         tput cnorm
		 echo -e "${lor7}---------------------------------------------------${lor7}"
        }

clear&&clear
echo -e "${lor1}===================================================${lor7} "
echo -e "${lor2}              SSL STUNNEL  |  VPS-VIP "
echo -e "${lor1}===================================================${lor7} "
echo -e "${lor4}$b ${lor7}"
echo -e "${lor1}[-]——————————————————————————————————————————————[-]${lor7}"
[[ $(netstat -nplt |grep 'stunnel4') ]] && sessl="DETENER SERVIDOR ${lor2}ON" || sessl="INICIAR SERVIDOR ${lor1}OFF"
echo -e "${lor7}[${lor2}1${lor7}] ${lor3}==>${lor7} INSTALAR SSL STUNNEL"
echo -e "${lor7}[${lor2}2${lor7}] ${lor3}==>${lor7} DESINTALAR SSL STUNNEL "
echo -e "${lor7}[${lor7}3${lor7}] ${lor3}==>${lor7} AÑADIR NUEVO PORT "
echo -e "${lor7}[${lor2}4${lor7}] ${lor3}==>${lor7} $sessl "
echo -e "${lor1}[-]——————————————————————————————————————————————[-]${lor7}"
echo -e "${lor7}[${lor2}5${lor7}] ${lor3}==>${lor7} CERTIFICADO ZERO-SSL "
echo -e "${lor7}[${lor2}6${lor7}] ${lor3}==>${lor7} WEBSOCKET NODE"
echo -e "${lor1}[-]——————————————————————————————————————————————[-]${lor7}"
echo -e "${lor7}[${lor2}0${lor7}] ${lor3}==>${lor7} SALIR DEL PROTOCOLO"
echo -e "${lor1}[-]——————————————————————————————————————————————[-]${lor7}"
read -p "SELECT OPTION :" opci

#opc1
if [ "$opci" = "1" ];then
if [ -f /etc/stunnel/stunnel.conf ]; then
echo;echo -e "${lor1}  ALREADY INSTALLED" 
else
echo;echo -e "${lor7} Local port  ${lor6}"
pt=$(netstat -nplt |grep 'sshd' | awk -F ":" NR==1{'print $2'} | cut -d " " -f 1)
read -p " :" -e -i $pt PT
echo;echo -e "${lor7} Listen-SSL  ${lor6}"
read -p " :" sslpt
if [ -z $sslpt ]; then
echo;echo -e "${lor1}  INVALID PORT"  
else 
if (echo $sslpt | egrep '[^0-9]' &> /dev/null);then
echo;echo -e "${lor1}  YOU MUST ENTER A NUMBER" 
else
if lsof -Pi :$sslpt -sTCP:LISTEN -t >/dev/null ; then
echo;echo -e "${lor1}  THE PORT IS ALREADY IN USE"  
else
inst_ssl () {
apt-get purge stunnel4 -y 
apt-get purge stunnel -y
apt-get install stunnel -y
apt-get install stunnel4 -y
pt=$(netstat -nplt |grep 'sshd' | awk -F ":" NR==1{'print $2'} | cut -d " " -f 1)
echo -e "cert = /etc/stunnel/stunnel.pem\nclient = no\nsocket = a:SO_REUSEADDR=1\nsocket = l:TCP_NODELAY=1\nsocket = r:TCP_NODELAY=1\n\n[stunnel]\nconnect = 127.0.0.1:${PT}\naccept = ${sslpt}" > /etc/stunnel/stunnel.conf
openssl genrsa -out key.pem 2048 > /dev/null 2>&1
(echo br; echo br; echo uss; echo speed; echo pnl; echo ghost; echo @ghost)|openssl req -new -x509 -key key.pem -out cert.pem -days 1095 > /dev/null 2>&1
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
rm -rf key.pem;rm -rf cert.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart
service stunnel restart
service stunnel4 start
}

inst_ssl
echo;echo -e "${lor2}  SSL STUNNEL INSTALLED " 
fi;fi;fi;fi
fi

#opci6
if [ "$opci" = "6" ]; then
install_ini () {
clear
msg -bar
echo -e "\033[92m        -- INSTALANDO PAQUETES NECESARIOS -- "
msg -bar
#dropbear
[[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] || apt-get install dropbear -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "dropbear"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install dropbear................ $ESTATUS "
#nodejs
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] || apt-get install nodejs -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install nodejs.................. $ESTATUS "
#build-essential
[[ $(dpkg --get-selections|grep -w "build-essential"|head -1) ]] || apt-get install build-essential -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "build-essential"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "build-essential"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install build-essential......... $ESTATUS "
#PV
[[ $(dpkg --get-selections|grep -w "pv"|head -1) ]] || apt-get install pv -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "pv"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "pv"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install PV   ................... $ESTATUS "
msg -bar
echo -e "\033[92m La instalacion de paquetes necesarios a finalizado"
msg -bar
echo -e "\033[97m Si la instalacion de paquetes tiene fallas"
echo -ne "\033[97m Puede intentar de nuevo [s/n]: "
read inst
[[ $inst = @(s|S|y|Y) ]] && install_ini
}

fun_log () {
[[ -e /bin/ejecutar/sshd_config ]] && { 
####
sysvar=$(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //' | grep -o Ubuntu)
[[ ! $(cat /etc/shells|grep "/bin/false") ]] && echo -e "/bin/false" >> /etc/shells
[[ "$sysvar" != "" ]] && {
echo -e "Port 22
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
Banner /etc/bannerssh" > /etc/ssh/sshd_config
} || {
echo -e "Port 22
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
Banner /etc/bannerssh" > /etc/ssh/sshd_config
}
} || {
cp /etc/ssh/sshd_config /bin/ejecutar/sshd_config
sysvar=$(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //' | grep -o Ubuntu)
[[ ! $(cat /etc/shells|grep "/bin/false") ]] && {
sed -i "s;/bin/false;;g" /etc/shells
sed -i "s;/usr/sbin/nologin;;g" /etc/shells
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
}
[[ "$sysvar" != "" ]] && {
echo -e "Port 22
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
Banner /etc/bannerssh" > /etc/ssh/sshd_config
} || {
echo -e "Port 22
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
Banner /etc/bannerssh" > /etc/ssh/sshd_config
}
}
######################

}

car_cert () {
[[ -e /etc/stunnel/stunnel.pem ]] && echo -e "Ya Existe un certificado SSL Cargado \n  Recuerde Cargar SU Certificado y Key del SSL " | pv -qL 25
msg -bar
echo -e "Descarga el fichero URL del Certificado SSL " 
echo -e $barra
		echo -e "		\033[4;31mNOTA importante\033[0m"
		echo -e " \033[0;31mPara este Paso debes tener el URL del certificado Online"
		echo -e "            Si Aun no lo has hecho, Cancela este paso"
		echo -e "               Evitar Errores Futuros"
		echo -e "   y causar problemas en futuras instalaciones.\033[0m"
		echo -e $barra
msg -bar
echo -e "Ingrese Link del Fichero URL de tu ZIP con los Certificados "
msg -bar
read -p " Pega tu Link : " urlm
wget -O certificados.zip $urlm && echo -e "Descargando Fichero ZIP " || echo "Link de descarga Invalido"
msg -bar
echo -ne "\033[1;42m ZIPS Existentes : " && ls | grep zip && echo -e "\033[1;42m"
msg -bar 
unzip certificados.zip 1> /dev/null 2> /dev/null && echo -e "Descomprimiendo Ficheros descargados" || echo -e "Error al Descomprimir "
[[ -e private.key ]] && cat private.key > /etc/stunnel/stunnel.pem && echo -e " \033[1;42m Key del Certificado cargada Exitodamente\033[0m" || echo -e " \033[1;41mClaves Invalidas\033[0m"
[[ -e certificate.crt && -e ca_bundle.crt ]] && cat certificate.crt ca_bundle.crt >> /etc/stunnel/stunnel.pem && echo -e "\033[1;42m  CRT del Certificado cargada Exitodamente\033[0m" || echo -e "\033[1;41mClaves Invalidas\033[0m"
rm -f private.key certificate.crt ca_bundle.crt certificados.zip 1> /dev/null 2> /dev/null && cd $HOME
unset porta1
if [[ -z $porta1  ]]; then
	porta1="443"
fi
msg -bar
    while true; do
    echo -ne "\033[1;37m"
    echo " $(source trans -b pt:${id} "Ingresa Puerto SSL a USAR ( Defauld 443 ) ") "
    read -p " Listen-Dropbear: " porta1
    [[ $(mportas|grep $porta1) ]] || break
    echo -e "\033[1;33m $(source trans -b es:${id} "El puerto seleccionado ya se encuentra en uso")"
    unset porta1
	msg -bar
	return 0
    done
unset porta1ws
msg -bar
echo -e "\033[1;33m $(source trans -b pt:${id} "Instalando SSL/TLS : ")$(curl -sSL ipinfo.io > info && cat info | grep country | awk '{print $2}' | sed -e 's/[^a-z0-9 -]//ig')"
msg -bar
fun_bar "apt install stunnel4 -y"
echo -e "cert = /etc/stunnel/stunnel.pem\nclient = no\nsocket = a:SO_REUSEADDR=1\nsocket = l:TCP_NODELAY=1\nsocket = r:TCP_NODELAY=1\n\n[WS]\nconnect = 127.0.0.1:80\naccept = ${SSLPORT}" > /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart > /dev/null 2>&1
msg -bar
#echo "Limpiando sistema y Reiniciando Servicios"
echo 3 > /proc/sys/vm/drop_caches 1> /dev/null 2> /dev/null
sysctl -w vm.drop_caches=3 1> /dev/null 2> /dev/null
swapoff -a && swapon -a 1> /dev/null 2> /dev/null
service ssh restart 1> /dev/null 2> /dev/null
echo -e "\033[1;34m ##############################"
echo -e "\033[1;37m R E I N I C I A N D O  -  STUNNEL4 - SSL"
echo -e "\033[1;34m ##############################"
echo -e "\033[1;33m $(source trans -b pt:${id} "INSTALACION EXITOSA")"
msg -bar
}

insta_ser () {
#sudo apt install dropbear squid stunnel cmake make gcc build-essential nodejs
#nano /etc/default/dropbear
unset porta1
if [[ -z $porta1  ]]; then
	porta1="143"
fi
msg -bar
    while true; do
    echo -ne "\033[1;37m"
    echo " $(source trans -b pt:${id} "Ingresa Puerto Dropbear/SSH a USAR ( Defauld 443 ) ") "
    read -p " Listen-Dropbear: " porta1
    [[ $(mportas|grep $porta1) ]] || break
    echo -e "\033[1;33m $(source trans -b es:${id} "El puerto seleccionado ya se encuentra en uso")"
    unset porta1
	msg -bar
	return 0
    done
unset porta1ws
if [[ -z $porta1ws  ]]; then
	porta1ws="80"
fi
msg -bar
    while true; do
    echo -ne "\033[1;37m"
    echo " $(source trans -b pt:${id} "Ingrese Puerto WebSocket ( Default 80 ) ") "
    read -p " Listen-WS: " porta1ws
	if lsof -Pi :$porta1ws -sTCP:LISTEN -t >/dev/null ; then
	echo -e "\033[1;33m $(source trans -b es:${id} "El puerto seleccionado ya se encuentra en uso")" 
    unset porta1ws
	msg -bar
	return 0
	else
	break
	fi
    done
msg -bar
service dropbear stop 1> /dev/null 2> /dev/null
rm -rf /etc/default/dropbear
echo -e "Habilitando Entrada Dropbear" | pv -qL 30
fun_log
echo -e "NO_START=0" > /etc/default/dropbear && echo -e "\033[1;33mExito" || echo -e "\033[0;31mFail"
echo -e "Habilitando Puerto $porta1 Dropbear" | pv -qL 30
#
echo $porta1 > /etc/default/dadd
echo -e 'DROPBEAR_EXTRA_ARGS="-p '$porta1'"' >> /etc/default/dropbear && echo -e "\033[1;33mExito" || echo -e "\033[0;31mFail"
echo -e "\033[1;32mHabilitando BannerSSH DropBear" | pv -qL 30
#
echo -e 'DROPBEAR_BANNER="/etc/bannerssh"' >> /etc/default/dropbear && touch /etc/bannerssh || echo -e "\033[0;31mFail"
echo -e "DROPBEAR_RECEIVE_WINDOW=65536" >> /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service dropbear restart 1> /dev/null 2> /dev/null && echo -e "\033[1;32mReiniciando DropBear Exitosamente" | pv -qL 30 || echo -e "\033[1;32mError al Reiniciar DropBear" | pv -qL 30
service sshd restart 1> /dev/null 2> /dev/null
service ssh restart 1> /dev/null 2> /dev/null
dropbearports=`netstat -tunlp | grep dropbear | grep 0.0.0.0: | awk '{print substr($4,9); }' > /tmp/dropbear.txt && echo | cat /tmp/dropbear.txt | tr '\n' ' ' > /etc/adm-lite/dropbearports.txt && cat /etc/adm-lite/dropbearports.txt`;
echo -e "\033[1;31m › DROPBEAR ESCUCHA \033[0m" $porta1 " ESCOJIDO " $porta1
msg -bar
echo -e "Creando Directorios" | pv -qL 30
#
[[ -d /bin/ejecutar ]] && rm -f /bin/ejecutar/proxy3.js || mkdir /bin/ejecutar
cd /bin/ejecutar
echo -e "Descargando Ficheros JS" | pv -qL 30
wget -q https://raw.githubusercontent.com/FOX-GOD/ADM-WOLI/FOX-GOD-patch-1/ArchUtils/proxy3.js
echo -e "\033[1;32mHabilitando NODE WS" | pv -qL 30
#
echo -e "Iniciando NODE WS" | pv -qL 30
#
screen -dmS ws node /bin/ejecutar/proxy3.js -dport $porta1 -mport $porta1ws
cd $HOME
echo -e "Mostrando Status NODE WS\n  ----------- Presiona CNTRL + X para Salir ------------"
echo -e $barra
		echo -e "		\033[4;31mNOTA importante\033[0m"
		echo -e " \033[0;31m   USA este Payload "
		echo -e "   En el Menu de Seleccion.\033[0m"
		echo -e $barra
echo ' GET / HTTP/1.1[crlf]Host: yourhost.com[crlf]
 Connection: Upgrade[crlf]User-Agent: [ua][crlf]
 Upgrade: websocket[crlf][crlf] '
echo -e $barra
#read -p "Presiona Enter para Continuar"
#
#[[ -e /etc/systemd/system/nodews1.service ]] && systemctl status nodews1 || echo -e "Error al Iniciar NODE WS" | pv -qL 15
echo -e $barra
echo -e "\033[1;33m › INSTALACION FINALIZADA - PRESIONE ENTER\033[0m"
read -p " "
}

insta_https () {
unset porta1
sslports=`netstat -tunlp | grep stunnel4 | grep 0.0.0.0: | awk '{print substr($4,9); }' > /tmp/ssl.txt && echo | cat /tmp/ssl.txt | tr '\n' ' ' > /etc/newadm/sslports.txt && cat /etc/newadm/sslports.txt`;
PORT=$(cat /etc/newadm/sslports.txt  | sed 's/\s\+/,/g' | cut -d , -f1)
echo -e " Ingrese Puerto SSL/SSH/Dropbear Activo"
read -p " Para Redireccionamiento ( Default $PORT ): " porta1
if [[ -z $porta1  ]]; then
	porta1="$PORT"
	echo -e "\033[1;31m › SSL ESCUCHA \033[0m $PORT "
fi
echo -e "\033[1;31m › Puerta Seleccionada \033[0m $porta1 "
unset porta1ws
#read -p "Ingrese Puerto WebSocket SSL ( Default 2083 ): " porta1ws
if [[ -z $porta1ws  ]]; then
	porta1ws="2083"
fi
msg -bar
    while true; do
    echo -ne "\033[1;37m"
    echo " $(source trans -b pt:${id} "Ingrese Puerto WebSocket ( Default 80 ) ") "
    read -p " Listen-WS: " porta1ws
    [[ $(mportas|grep $porta1ws) ]] || break
    echo -e "\033[1;33m $(source trans -b es:${id} "El puerto seleccionado ya se encuentra en uso")"
    unset porta1ws
	msg -bar
	return 0
    done
msg -bar
if lsof -Pi :$porta1ws -sTCP:LISTEN -t >/dev/null ; then
echo "Ya esta en uso ese puerto"
exit
else
echo -e "Creando Directorios" | pv -qL 15
#
[[ -d /bin/ejecutar ]] && echo "Fichero Existente" || mkdir /bin/ejecutar
cd /bin/ejecutar
echo -e "Descargando Ficheros JS" | pv -qL 15
wget -O httpsProxy.js -q https://raw.githubusercontent.com/FOX-GOD/ADM-WOLI/FOX-GOD-patch-1/ArchUtils/proxy3.js
echo -e "\033[1;32mHabilitando NODE WS" | pv -qL 15
#
echo -e "Iniciando NODE WS" | pv -qL 15
#
screen -dmS httpsws node /bin/ejecutar/httpsProxy.js -dport $porta1 -mport $porta1ws
cd $HOME
echo -e "Mostrando Status NODE WS\n  ----------- Presiona CNTRL + X para Salir ------------"
echo -e $barra
		echo -e "		\033[4;31mNOTA importante\033[0m"
		echo -e " \033[0;31m   USA este Payload "
		echo -e "   En el Menu de Seleccion.\033[0m"
		echo -e $barra
echo ' GET / HTTP/1.1[crlf]Host: yourhost.com[crlf]
 Connection: Upgrade[crlf]User-Agent: [ua][crlf]
 Upgrade: websocket[crlf][crlf] '
echo -e $barra
#read -p "Presiona Enter para Continuar"
#
#[[ -e /etc/systemd/system/nodews1.service ]] && systemctl status nodews1 || echo -e "Error al Iniciar NODE WS" | pv -qL 15
echo -e $barra
echo -e "\033[1;33m › INSTALACION FINALIZADA - PRESIONE ENTER\033[0m"
read -p " "
fi
}


stop_ser () {
killall node 
}


unset inst
clear
echo -e "\033[1;42mBIENVENIDO NUEVAMENTE!\033[0m"
echo -e $barra
		echo -e "        \033[4;31mNOTA importante\033[0m"
		echo -e "      \033[0;31mRecomendado UBUNTU 20.04"
		echo -e " Si Aun no lo has hecho, Dijita SI o s"
		echo -e "        Para Evitar Errores Futuros"
		echo -e " y causar problemas en futuras instalaciones.\033[0m"
		echo -e $barra
echo -e "Menu de instalacion de Paquetes Necesarios  "
echo -ne "\033[97m Deseas Instalar los Paquetes Requeridos [s/n]: "
read inst
[[ $inst = @(s|S|y|Y) ]] && install_ini
clear
msg -bar
echo -e "          \033[1;42mBIENVENIDO NUEVAMENTE!\033[0m"
msg -bar
echo -e " SSH OVER WEBSOCKET CDN  "
echo -e "\033[0;35m[\033[0;36m1\033[0;35m] \033[0;34m<\033[0;33m INICIAR WEBSOCKET CDN  (HTTP)  DROPBEAR"
echo -e "\033[0;35m[\033[0;36m2\033[0;35m] \033[0;34m<\033[0;33m INICIAR WEBSOCKET CDN  (HTTPS) SSL/SSH"
echo -e "\033[0;35m[\033[0;36m3\033[0;35m] \033[0;34m<\033[0;33m ACTIVAR CERTIFICADO SSL WEBSOCKET"
echo -e "\033[0;35m[\033[0;36m4\033[0;35m] \033[0;34m<\033[0;33m ELIMINAR PUERTOS WEBSOCKET CDN"
msg -bar
echo -e "\033[0;35m[\033[0;36m0\033[0;35m] \033[0;34m<\033[0;33m SALIR"
unset inst
msg -bar
echo -ne "\033[97m ESCOJE [ 0 / 4 ]: "
read inst
[[ $inst = "1" ]] && insta_ser
[[ $inst = "2" ]] && insta_https
[[ $inst = "3" ]] && stop_ser
[[ $inst = "4" ]] && car_cert
[[ $inst = "0" ]] && menu
echo "Instalacion Concluida con Exito"              
echo "PRESS ENTER TO RETURN" && read enter
fi

#opci2
if [ "$opci" = "2" ];then
del_ssl () {
service stunnel4 stop
apt-get remove stunnel4 -y
apt-get purge stunnel4 -y
apt-get purge stunnel -y
rm -rf /etc/stunnel
rm -rf /etc/stunnel/stunnel.conf
rm -rf /etc/default/stunnel4
rm -rf /etc/stunnel/stunnel.pem
}
del_ssl
echo;echo -e "${lor2}  SSL STUNNEL WAS REMOVED " 
fi

#opci3
if [ "$opci" = "3" ];then
if [ -f /etc/stunnel/stunnel.conf ]; then 
echo;echo -e "${lor7}Enter a name for the SSL Redirector${lor6}"
read -p " :" -e -i stunnel namessl
echo;echo -e "${lor7}Enter the port of the Service to bind${lor6}"
pt=$(netstat -nplt |grep 'sshd' | awk -F ":" NR==1{'print $2'} | cut -d " " -f 1)
read -p " :" -e -i $pt PT
echo;echo -e "${lor7}Enter the New SSL Port${lor6}"
read -p " :" sslpt
if [ -z $sslpt ]; then
echo;echo -e "${lor1}  INVALID PORT"  
else 
if (echo $sslpt | egrep '[^0-9]' &> /dev/null);then
echo;echo -e "${lor1}  YOU MUST ENTER A NUMBER" 
else
if lsof -Pi :$sslpt -sTCP:LISTEN -t >/dev/null ; then
echo;echo -e "${lor1}  THE PORT IS ALREADY IN USE"  
else
addgf () {		
echo -e "\n[$namessl] " >> /etc/stunnel/stunnel.conf
echo "connect = 127.0.0.1:$PT" >> /etc/stunnel/stunnel.conf 
echo "accept = $sslpt " >> /etc/stunnel/stunnel.conf 
service stunnel4 restart 1> /dev/null 2> /dev/null
service stunnel restart 1> /dev/null 2> /dev/null
sleep 2
}

addgf
echo;echo -e "${lor2} NEW PORT ADDED  $sslpt !${lor7}"
fi;fi;fi
else
echo;echo -e "${lor1} SSL STUNEEL NOT INSTALLED !${lor7}"
fi
fi

#opci4
if [ "$opci" = "4" ];then
if [ -f /etc/stunnel/stunnel.conf ];then
if netstat -nltp|grep 'stunnel4' > /dev/null; then
service stunnel stop 1> /dev/null 2> /dev/null
service stunnel4 stop 1> /dev/null 2> /dev/null
echo;echo -e "${lor1} SERVICE STOPPED "
else
service stunnel start 1> /dev/null 2> /dev/null
service stunnel4 start 1> /dev/null 2> /dev/null
echo;echo -e "${lor2} SERVICE STARTED "
fi
else
echo;echo -e "${lor1} SSL STUNNEL IS NOT INSTALLED "
fi
fi

#opci5
if [ "$opci" = "5" ];then
if [ -f /etc/stunnel/stunnel.conf ]; then
insapa2(){
for pid in $(pgrep python);do
kill $pid
done
for pid in $(pgrep apache2);do
kill $pid
done
service dropbear stop
apt install apache2 -y
echo "Listen 80
<IfModule ssl_module>
        Listen 443
</IfModule>
<IfModule mod_gnutls.c>
        Listen 443
</IfModule> " > /etc/apache2/ports.conf
service apache2 restart
}

insapa2
echo;echo -e "${lor7} Verify Domain ${lor6}"
read -p " KEY:" keyy
echo
read -p " DATA:" dat2w
mkdir -p /var/www/html/.well-known/pki-validation/
datfr1=$(echo "$dat2w"|awk '{print $1}')
datfr2=$(echo "$dat2w"|awk '{print $2}')
datfr3=$(echo "$dat2w"|awk '{print $3}')
echo -ne "${datfr1}\n${datfr2}\n${datfr3}" >/var/www/html/.well-known/pki-validation/$keyy.txt
echo;echo -e "${lor3} CHECK ON THE ZEROSSL PAGE ${lor7}"
read -p " ENTER TO CONTINUE"
echo;echo -e "${lor7} CERTIFICATE LINK ${lor6}"
echo -e "${lor6} LINK ${lor1}> ${lor7}\c"
read linksd
inscerts(){
wget $linksd -O /etc/stunnel/certificado.zip
cd /etc/stunnel/
unzip certificado.zip 
cat private.key certificate.crt ca_bundle.crt > stunnel.pem
service stunnel restart
service stunnel4 restart
}

inscerts
echo;echo -e "${lor2} CERTIFICATE INSTALLED ${lor7}" 
else
echo;echo -e "${lor1} SSL STUNNEL IS NOT INSTALLED "
fi
fi
#espe
if [ "$opci" = "0" ];then
exit
fi
read enter
#fin
