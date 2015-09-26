#!/bin/bash

#Welcome
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
NORMALG="\\033[1;39m"
ROUGE="\\033[1;31m"
JAUNE="\\033[1;33m"
BLEU="\\033[1;34m"
echo    ""
echo -e "$VERT" "    --------- ""$JAUNE""XIVO:""$ROUGE"" Log/unlog according to the phone status""$VERT"" ---------- " "$NORMAL"
echo            "    |              Written By H4wk3r(vdbnicolas@gmail.com)             |  "
echo -e "$VERT" "    ------------------------------------------------------------------     " "$NORMAL"

#Agent
source /opt/operatrice_agent.csv

#infinite loop
a=0;

#compter of mission
cmpt=1;

while [ a=0 ]; do
	if [ $cmpt -eq 1 ]; then
		sleep 3
	else
		sleep 42
	fi
	echo " "
	echo "         Mission: "$cmpt
	cmpt=$((cmpt+1))
	echo -e "$ROUGE" "-----------------------------     " "$NORMAL"
	for i in {720..759}; do 
		if [[ -n "${tab[i]}" ]]; then
			var1=$(asterisk -rx 'sip show peer poste'$i'' | grep -c OK); if [[ $var1 == 1 ]]; then 
					var2=$(xivo-agentctl -c 'status '${tab[i]}''| grep -c True); if [[ $var2 == 1 ]]; then
						echo -e "$BLEU" "POSTE"$i":" "$VERT" "CompteSIP connecte & Agent connecte" "$NORMAL"
					else
						echo -e "$BLEU" "POSTE"$i":" "$JAUNE"  "CompteSIP connecte & Agent non connecte" "$NORMAL"
					fi
			        	else if [[ $var1 == 0 ]]; then
                				var2=$(xivo-agentctl -c 'status '${tab[i]}''| grep -c True); if [[ $var2 == 1 ]]; then
						echo -e "$BLEU" "POSTE"$i":" "$NORMALG" "CompteSIP non connecte & Agent connecte : .... ""$ROUGE""DECONNEXION AGENT N°${tab[i]} : OK""$NORMAL"
        		                	xivo-agentctl -c 'logoff '${tab[i]}''
	                		else
                        			echo -e "$BLEU" "POSTE"$i":" "$NORMALG" "CompteSIP non connecte & Agent non connecte." "$NORMAL"
                			fi
				fi
        		fi
		fi
	done
done
