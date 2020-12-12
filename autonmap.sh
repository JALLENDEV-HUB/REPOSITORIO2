#!/bin/bash
# Define variables

#COLORES - DESTACAR EL ERROR
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 

function validar_ip()
{
    ip=$IP
    stat=1
    echo "ingresó esta IP .................... $ip "
    echo $ip
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}


pausa(){
  read -p "Presione [Enter] para continuar..." fackEnterKey
}
#Ingresar IP
uno(){
 	echo "Ingrese dirección IP:  "
	read IP 
	validar_ip
	if [ "$stat"  =  '1' ] ; 
	then
                      echo "IP no corresponde a formato : $IP "
  	   pausa
	fi
}
#Puertos Abiertos
dos(){
 	
	if [ $stat=0 ] 
	then
    		echo "Procesando Puertos Abiertos ...."
		sudo nmap  -p-  --open  -T5 -v  -n  $IP -oG allports > open.txt
		echo "Se ha creado archivo: open.txt"	
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi

}
 
#Script Vulnerabilidades
tres(){
	if [ $stat=0 ] 
	then
		echo "Procesando Vulnerabilidades...."
		sudo nmap -f  --script vuln $IP > vuln.txt
		echo "Se ha creado archivo: vuln.txt"
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi


}
#Script Autenticacion
cuatro(){
	if [ $stat=0 ] 
	then
		echo "Procesando Autenticación ...."
		sudo nmap -f -sS -sV --script auth $IP > autenticacion.txt
		echo "Se ha creado archivo: autenticacion.txt"
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi


}
#Script por defecto
cinco(){
	if [ $stat=0 ] 
	then
		echo "Procesando por Defecto ...."
		sudo nmap -f -sS -sV --script default $IP > default.txt
		echo "Se ha creado archivo: default.txt"
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi


}
#Script Seguro
seis(){
	if [ $stat=0 ] 
	then
		echo "Procesando Seguro ...."
		sudo nmap -f -sS -sV --script safe $IP > safe.txt
		echo "Se ha creado archivo: safe.txt"
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi


}
#Script Todos
siete(){
	if [ $stat=0 ] 
	then
		echo "Procesando todos los Script ...."
		sudo nmap -f -sS -sV --script all $IP > todos.txt
		echo "Se ha creado archivo: todos.txt"
		pausa
	else
		echo "Error Dirección IP"
		pausa
	fi


}
ocho(){
		echo "Procesando actualización de nmap...."
		#apt-get update $@
		sudo apt-get update
		echo "NMAP actualizado ..."
		nmap --version


		echo "Procesando actualización de BD Script ...."
		sudo nmap --script-updatedb
		echo "BD Script actualizado ..."
		pause


}
# function to display menus
menu() {
 	clear
 	echo "~~~~~~~~~~~~~~~~~~~~~" 
 	echo "  MENU-NMAP  "
 	echo $IP
 	echo "~~~~~~~~~~~~~~~~~~~~~"
 	echo "1. Ingresar IP"
 	echo "2. Escanear Puertos Abiertos"
	echo "3. Script Vulnerabilidades"
	echo "4. Script Autenticación"
	echo "5. Script por Defecto"
	echo "6. Script Seguro"
	echo "7. Script Todos - No recomendado"
	echo "8. Actualizar NMAP"
 	echo "9. Exit"
}

opciones(){
 	local opcion
	read -p "Ingrese opción [ 1 - 9] " opcion
 	case $opcion in
 	1) uno;;
	2) dos;;
	3) tres;;
	4) cuatro;;
	5) cinco;;
	6) seis;;
	7) siete;;
	8) ocho;;
	9) exit 0;;
  *) echo -e "${RED}Error...${STD}" && sleep 2
 esac
}
 

trap '' SIGINT SIGQUIT SIGTSTP
 

while true
do
 
menu
opciones
done
