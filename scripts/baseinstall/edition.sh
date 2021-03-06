#!/bin/bash
#
# [PlexGuide Menu]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
export NCURSES_NO_UTF8_ACS=1

mkdir -p /var/plexguide/hd 1>/dev/null 2>&1
#hd1=$( cat /var/plexguide/hd/hd1 )

HEIGHT=12
WIDTH=36
CHOICE_HEIGHT=5
BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
TITLE="Select Your Edition!"

OPTIONS=(A "GDrive Edition"
         B "HD Solo Edition"
         C "HD Multiple Edition (TEST)"
         D "Mini FAQ"
         Z "Exit")

CHOICE=$(dialog --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
    A)
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working one may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0
      rm -r /var/plexguide/pg.edition 1>/dev/null 2>&1
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then

          ### If SOLO Drive was active before, important to move item to an old folder
          deploy=$( cat /var/pg.server.deploy )
          if [ "$deploy" == "drive" ]
            then
              dialog --title "Quick Note" --msgbox "\nWARNING! Your Items from /mnt/unionfs need to move to either /mnt/old/ for storage reasons or /mnt/move for GDrive Uploading!" 0 0
              
                ### Make a Move Choice
                HEIGHT=12
                WIDTH=44
                CHOICE_HEIGHT=5
                BACKTITLE="Visit PlexGuide.com - Automations Made Simple"
                TITLE="Select Your Edition!"

                OPTIONS=(A "To /mnt/old  - For Storage"
                         B "To /mnt/move - For Google Uploads")

                CHOICE=$(dialog --backtitle "$BACKTITLE" \
                                --title "$TITLE" \
                                --menu "$MENU" \
                                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                                "${OPTIONS[@]}" \
                                2>&1 >/dev/tty)

                case $CHOICE in
                A)
                dialog --title "Quick Note" --msgbox "\nTo /mnt/old your DATA for storage it goes!" 0 0
                mkdir /mnt/old 1>/dev/null 2>&1
                mv /mnt/unionfs/* /mnt/old 1>/dev/null 2>&1
                ;;
                B)
                dialog --title "Quick Note" --msgbox "\nTo /mnt/move your DATA for uploading it goes!" 0 0
                mv /mnt/unionfs/* /mnt/move 1>/dev/null 2>&1
                ;;
                esac
          fi

        ### Set Everything for GDrive Editon
        echo "PG Edition: GDrive" > /var/plexguide/pg.edition
        echo "gdrive" > /var/pg.server.deploy
        bash /opt/plexguide/menus/main.sh
        exit
      else 
        bash /opt/plexguide/scripts/baseinstall/edition.sh  
        exit
      fi

      exit
      ;;

    C)
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0

      rm -r /var/plexguide/pg.edition 1>/dev/null 2>&1
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then
        echo "PG Edition: HD Multiple" > /var/plexguide/pg.edition
        echo "drives" > /var/pg.server.deploy
        bash /opt/plexguide/menus/drives/multideploy.sh
        bash /opt/plexguide/menus/localmain.sh
        exit
      else 
        bash /opt/plexguide/scripts/baseinstall/edition.sh  
        exit
      fi

      exit
      ;;

    B)
      dialog --title "Quick Note" --msgbox "\nWARNING! Switching to another edition from a previous working may result in certain things being shutdown!\n\nWe will do our best to ensure that you can transition to any edition!" 0 0

      rm -r /var/plexguide/pg.edition 1>/dev/null 2>&1
      bash /opt/plexguide/menus/confirm.sh 

      ### Confirm yes or no to skip back to menu    
      menu=$( cat /tmp/menu.choice )
      if [ "$menu" == "yes" ]
        then
        ansible-playbook /opt/plexguide/ansible/plexguide.yml --tags folders_solo &>/dev/null &
        echo "PG Edition: HD Solo" > /var/plexguide/pg.edition
        echo "drive" > /var/pg.server.deploy
        bash /opt/plexguide/menus/drives/solodeploy.sh
        bash /opt/plexguide/menus/localmain.sh
        exit
      else 
        bash /opt/plexguide/scripts/baseinstall/edition.sh  
        exit
      fi

      exit
      ;;
    D)
      dialog --title "Quick FAQ" --msgbox "\nYou can pick between using your local drives or Google Drive for your mass media storage collection.\n\nBe aware the HDs option is not ready and is here for testing/demo purposes until ready.\n\nSolo HD is setup for smaller collections; download, watch, and delete. The multiple HD edition is for those who use multiple drives to build a collection!" 0 0
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
    Z)
      bash /opt/plexguide/scripts/baseinstall/edition.sh  
      exit
      ;;
esac
#bash /opt/plexguide/scripts/baseinstall/edition.sh  