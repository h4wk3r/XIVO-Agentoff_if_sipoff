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
echo " "

#infinite loop
a=0;
#compter of mission
cmpt=1;
#for delete \SIP.
remplace=''

while [ a=0 ]; do
	#wait enter mission
	if [ $cmpt -eq 1 ]; then
		sleep 3
	else
		sleep 42
	fi
	echo " "
	echo -e "$NORMALG""  ----------------""$ROUGE Traitement : "$cmpt"$NORMALG ------------------$NORMAL"
	#table - n°Agent; table - extension; table - Name users SIP 
	i=0; while IFS='|' read -r num ext int; do agent_num[i]=$num extension[i]=$ext state_interface[i]=$int; ((i++)); done < <(sudo -u asterisk psql -tAc "select agent_number,extension,state_interface from agent_login_status;")
	i=$((i-1))
	#i is nbr _ ligne
	for j in `seq 0 $i`; do		
		#treatment state_interface
		#agent whit extension
		echo -e "\t""$JAUNE""<""$NORMALG""  AGENT N°:${agent_num[j]}  ""$JAUNE"" |""$NORMALG""  TELEPHONE N°:${extension[j]} ""$JAUNE"">""$NORMAL"
		#check agent
		if [[ -n "${agent_num[j]}" ]]; then
			#check SIP
			status_exten=$(asterisk -rx 'sip show peer '${state_interface[j]//SIP\//$replace}'' | grep -c OK)
			if [[ $status_exten == 1 ]]; then
				#check Agent
				status_agent=$(xivo-agentctl -c 'status '${agent_num[j]}''| grep -c True)
				if [[ $status_agent == 1 ]]; then
					echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$VERT" "CompteSIP connecte & Agent connecte" "$NORMAL"
				else
					echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$JAUNE" "CompteSIP connecte & Agent non connecte" "$NORMAL"
				fi
			else if [[ $status_exten == 0 ]]; then
               			status_agent=$(xivo-agentctl -c 'status '${agent_num[j]}''| grep -c True)
			 	if [[ $status_agent == 1 ]]; then
					echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$ROUGE" "CompteSIP non connecte & Agent connecte : .... DECONNEXION AGENT N°""${agent_num[j]}"" : OK""$NORMAL"
        	                	xivo-agentctl -c 'logoff '"${agent_num[j]}"''
				else
					echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$NORMALG" "Compte SIP deconnecte et Agent déconnecte" "$NORMAL"
				fi
			fi
		fi
		else
			echo "CET AGENT N'EXISTE PAS OU IL EST DECONNECTE !"
		fi
	done
	cmpt=$((cmpt+1))
done
