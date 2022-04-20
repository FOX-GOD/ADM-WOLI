#!/bin/bash
#19/06/2021

echo "/root/velocity" > /bin/vlc && chmod +x /bin/vlc > /dev/null 2>&1
link_bin="https://raw.githubusercontent.com/FOX-GOD/ADM-WOLI/FOX-GOD-patch-1/Filescph/speedtest"
[[ ! -e /bin/speedtest ]] && wget -O /bin/speedtest ${link_bin} > /dev/null 2>&1 && chmod +x /bin/speedtest

inst_components () {
[[ $(dpkg --get-selections|grep -w "python"|head -1) ]] || apt-get install python -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "python3"|head -1) ]] || apt-get install python3 -y &>/dev/null
}

velocity () {

aguarde () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} > /dev/null 2>&1
${comando[1]} > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mEspere \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;Haciendo Test \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

fun_tst () {
speedtest --share > speed
}
echo ""
clear
echo -e "\033[0;34m======================================================\033[0m"
echo -e " \033[1;33m         SpeedTest \033[1;32m[ VPS-BO ]              \033[0m"
echo -e "\033[0;34m======================================================\033[0m"
echo ""
inst_components
apt-get install python-pip -y  > /dev/null 2>&1
pip install speedtest-cli  > /dev/null 2>&1
aguarde 'fun_tst'
echo ""
png=$(cat speed | sed -n '5 p' |awk -F : {'print $NF'})
down=$(cat speed | sed -n '7 p' |awk -F :  {'print $NF'})
upl=$(cat speed | sed -n '9 p' |awk -F :  {'print $NF'})
lnk=$(cat speed | sed -n '10 p' |awk {'print $NF'})
echo -e "\033[0;34m======================================================\033[0m"
echo -e "\033[1;32mPING (LATENCIA):\033[1;37m$png"
echo -e "\033[1;32mDOWNLOAD:\033[1;37m$down"
echo -e "\033[1;32mUPLOAD:\033[1;37m$upl"
echo -e "\033[1;32mLINK: \033[1;36m$lnk\033[0m"
echo -e "\033[0;34m======================================================\033[0m"
rm -rf $HOME/speed
echo
read enter
}
velocity
#fim...!!!!! <<<" && read enter
