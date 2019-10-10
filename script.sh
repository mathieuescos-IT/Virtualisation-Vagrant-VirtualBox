#!/bin/sh

menu() {
    clear
    echo " -----  Bienvenue sur l'installation complète de Virtualbox & Vagrant -----   "
    echo " "
    echo " 1 - Vérifier si Virtualbox & Vagrant sont installés"
    echo " 2 - Commencer une nouvelle installation de Virtualbox & Vagrant"
    echo " 3 - Quitter le programme"
    echo " "
}
menu
while read -p "Saississez le numéro de votre choix (1, 2 ou 3)" numMenu; do
    case $numMenu in
        1)
          clear
          read -p "Je vais proceder à la recherche des commandes Vagrant & Virtualbox. Êtes-vous toujours ok ? (o/n)" responseVerif
          if [[ $responseVerif == "o" ]]; then
            echo "OK Vamos ! je lance la vérification"
            sleep 3
            if [[ "$(type -t vagrant)" && "$(type -t virtualbox)" ]]; then
              read -p "Tout est bien installer ! Retour au menu (taper entrée)..."
              menu
            else
              echo "Un des deux paquets n'est pas installer ! Retour au menu (taper entrée...)"
              menu
            fi
          elif [[ $responseVerif == "n" ]]; then
            echo "OK BYE ! Retour au menu... (taper entrée)"
            menu
          else
            echo "La réponse n'est pas attribué, répondez uniquement par o ou n" && sleep 2
          fi
        menu;;

        2)
          clear
          echo "---- SET UP VIRTUALBOX & VAGRANT -----"
          echo " "
          read -p "Voulez-vous installer Virtualbox & vagrant ? (oui/non)" installVirtualbox
          if [[ $installVirtualbox == "oui" ]]; then
            clear
            echo "Installation de VIRTUALBOX"
            sudo apt install virtualbox -y
          elif [[ $installVirtualbox == "non" ]]; then
            echo "D'accord, retournons au menu (tapée entrée)"
            menu
          else
            echo "Réponse non appropriée" && sleep 2
          fi
          clear
          read -p "Voulez-vous installer vagrant ? (oui/non)" installVagrant
          if [[ $installVagrant == "oui" ]]; then
            clear
            echo "Installation de VIRTUALBOX"
            sudo apt install vagrant -y
          elif [[ $installVagrant == "non" ]]; then
            echo "D'accord, retournons au menu (tapée entrée)"
            menu
          else
            echo "Réponse non appropriée" && sleep 2
          fi
          clear
          if [[ ! -e Vagrantfile ]]; then
            read -p "OK ! Passons à la suite ! Configurons maintenant vagrant ! (tapée entrée)"
            echo " "
            echo " ----------- Création du fichier Vagrant ----------"
            echo " "
            vagrant init
            clear
            echo " 1- ubuntu/xenial64"
            echo " 2- ubuntu/trusty64"
            echo " 3 - ubuntu/precise64"
            read -p "Quelle box voulez vous installer pour la création de Vagrant : (1, 2,  3)" boxChoice

            if [[ $boxChoice == 1 ]]; then
                box="ubuntu/xenial64"
                echo "Vagrant.configure("2") do |config|" > Vagrantfile
                echo "config.vm.box = \"$box\"" >> Vagrantfile
            elif [[ $boxChoice == 2 ]]; then
                box="ubuntu/trusty64"
                echo "Vagrant.configure("2") do |config|" > Vagrantfile
                echo "config.vm.box = \"$box\"" >> Vagrantfile
            elif [[ $boxChoice == 3 ]]; then
                box="ubuntu/precise64"
                echo "Vagrant.configure("2") do |config|" > Vagrantfile
                echo "config.vm.box = \"$box\"" >> Vagrantfile
            else
                echo "Erreur lors de la saisie, réessayer" && sleep 2
            fi

            clear
            read -p "Quelle ip voulez-vous mettre (défaut : 192.168.33.10)" ipChoice
            echo "config.vm.network \"private_network\", ip: \"$ipChoice\"" >> Vagrantfile

            clear
            read -p "Quelle nom du dossier local voulez-vous mettre ? (défaut = /data/)" folderLocalName
            echo "config.vm.synced_folder \"$folderLocalName\", \"/vagrant_data\"" >> Vagrantfile

            clear
            # ---- JE n'ai pas su changer le dossier distant --- #

            echo "end" >> Vagrantfile

            echo "Tout est installer suivant vos modifications"
            clear
            echo " Voici toutes les vagrants disponible ainsi que leur status"
            vagrant general-status
          else
            echo "Votre Vagrantfile est déjà existant."
          fi
          read -p "VOulez-vous voir toutes vos machines ? (oui/non)" responseStatus
          if [[ $responseStatus == "oui" ]]
          then
            vagrant global-status
          else
            read -p "ok continuons, voulez-vous lancer votre machine ? (oui/non)" responseSetUp*
            vagrant up
          fi

        menu;;

          3)
          break;;
          *)
          echo "Erreur lors de la saisie" && sleep 2
      esac
      menu
  done
  echo "Vous avez quitter le script"
