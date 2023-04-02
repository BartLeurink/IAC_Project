#!/bin/bash

#Functie die het RAM aanpast van een server. Gebruikt 2 argumenten, de naam van de webserver en de hoeveelheid RAM die wordt toegekend
function CHANGE_RAM () {
        sed -i "s|$1.memory =.*|$1.memory = $2|g" Vagrantfile
	vagrant reload $1
}

#Functie die het aantal webservers aanpast. Gebruikt 1 argument. Past de for-loop aan in de Vagrantfile
#Deze functie past het aantal webservers aan.
function CHANGE_WEBSERVERS () {
	sed -i "s|aantalWebservers =.*|aantalWebservers = $1|g" Vagrantfile
	vagrant up
}

echo "geef aan welke taak je wil uitvoeren?"

select task in\
	"Werkgeheugen van een server aanpassen"\
	"Aantal webservers aanpassen"\
	"Testwebservers uitrollen"
do
	if [ "$task" = "Werkgeheugen van een server aanpassen" ];
	then
		echo "Van welke server wil je het geheugen aanpassen?"
		read server
		echo "Hoeveel MB geheugen wil je toekennen?"
		read varMB
		CHANGE_RAM $server $varMB
	break
	elif [ "$task" = "Aantal webservers aanpassen" ];
	then
		echo "Hoeveel webservers wil je actief hebben"
		read actieveWebservers
		CHANGE_WEBSERVERS $actieveWebservers
	break
	elif [ "$task" = "Testwebservers uitrollen" ];
        then
                echo "Via dit menu kunnen er testwebservers uitgerold worden"
		echo "Hoeveel testwebservers moeten er uitgerold worden?"
                read aantalTestWebservers
		echo "Geef jou klantnummer op: "
		read klantnummer
		mkdir /media/bart/Vagrant/IAC/testomgeving
		echo "Map voor testomgeving aangemaakt"
		cp /media/bart/Vagrant/IAC/playbook.yml /media/bart/Vagrant/IAC/testomgeving/playbook.yml
		cp /media/bart/Vagrant/IAC/ansible.cfg /media/bart/Vagrant/IAC/testomgeving/ansible.cfg
		cp /media/bart/Vagrant/IAC/VagrantfileTemplate /media/bart/Vagrant/IAC/testomgeving/VagrantfileTestomgeving
		echo "Bestanden en Vagrantfile gekopieerd"
		sed -i "s|aantalWebservers =.*|aantalWebservers = $aantalTestWebservers|g" /media/bart/Vagrant/IAC/testomgeving/VagrantfileTestomgeving
		sed -i "s|klantnummer =.*|klantnummer = $klantnummer|g" /media/bart/Vagrant/IAC/testomgeving/VagrantfileTestomgeving
		sed -i "s|node.vm.hostname = "webserver0#{i}"|node.vm.hostname = "TestWebserver0#{i}"|g" /media/bart/Vagrant/IAC/testomgeving/VagrantfileTestomgeving
		echo "Parameters doorgevoerd voor Testwebservers"
		start=1
		for i in $(eval echo "{$start..$aantalTestWebservers}")
		do
			echo "Testweb0${i} ansible_host=192.168.56.${klantnummer}${i} ansible_ssh_private_key_file=/media/bart/Vagrant/IAC/.ssh/id_rsa" >> /media/bart/Vagrant/IAC/inventory.yml
		done
		echo "Testomgeving staat klaar om te runnen"
		cd ./testomgeving
		VAGRANT_VAGRANTFILE=VagrantfileTestomgeving vagrant up
        break
	else
		echo "Selecteer een geldige taak"
	fi
done
