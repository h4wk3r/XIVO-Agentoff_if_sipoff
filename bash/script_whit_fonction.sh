#!/bin/bash

VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
NORMALG="\\033[1;39m"
ROUGE="\\033[1;31m"
JAUNE="\\033[1;33m"
BLEU="\\033[1;34m"
cmpt=1


prez()
{
	echo    ""
	echo -e "$VERT" "    --------- ""$JAUNE""XIVO:""$ROUGE"" Log/unlog according to the phone status""$VERT"" ---------- " "$NORMAL"
	echo            "    |              Written By H4wk3r(vdbnicolas@gmail.com)             |  "
	echo -e "$VERT" "    ------------------------------------------------------------------     " "$NORMAL"
	echo " "
}

wait()
{
        if [ $cmpt -eq 1 ]; then
                sleep 3
        else
                sleep 42
        fi
}

table()
{
	#i = nb_ligne
	i=0 
	while IFS='|' read -r num ext int; do
		agent_num[i]=$num extension[i]=$ext state_interface[i]=$int
		((i++)); done < <(sudo -u asterisk psql -tAc "select agent_number,extension,state_interface from agent_login_status;")
}

display_agent_exten()
{
                echo -e "\t""$JAUNE""<""$NORMALG""  AGENT N°:${agent_num[j]}  ""$JAUNE"" |""$NORMALG""  TELEPHONE N°:${extension[j]} ""$JAUNE"">""$NORMAL"
}

check_sip()
{
	#for delete \SIP.
	remplace=''
	status_exten=$(asterisk -rx 'sip show peer '${state_interface[j]//SIP\//$replace}'' | grep -c OK)
}

check_agent()
{
	status_agent=$(xivo-agentctl -c 'status '${agent_num[j]}''| grep -c True)
}

display_true()
{
	if [[ $status_agent == 1 ]]; then
        	echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$VERT" "CompteSIP connecte & Agent connecte" "$NORMAL"
        else
        	echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$JAUNE" "CompteSIP connecte & Agent non connecte" "$NORMAL"
        fi
}

display_false()
{
        if [[ $status_agent == 1 ]]; then
                echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$ROUGE" "CompteSIP non connecte & Agent connecte : .... DECONNEXION AGENT N°""${agent_num[j]}"" : OK""$NORMAL"
        	xivo-agentctl -c 'logoff '"${agent_num[j]}"''
        else
	        echo -e "$BLEU" "AGENT""${agent_num[j]}:" "$NORMALG" "Compte SIP deconnecte et Agent déconnecte" "$NORMAL"
	fi
}

#script bash
prez
while true; do
        wait
        echo " "
        echo -e "$NORMALG""  ----------------""$ROUGE Traitement : "$cmpt"$NORMALG ------------------$NORMAL"
        table
        i=$((i-1))
        for j in `seq 0 $i`; do
                display_agent_exten j agent_num[j] extension[j] 
                if [[ -n "${agent_num[j]}" ]]; then
                        check_sip j state_interface
                        if [[ $status_exten == 1 ]]; then
                                check_agent j agent_num
                                display_true j status_agent agent_num
                        else if [[ $status_exten == 0 ]]; then
                                check_agent j agent_num
                                display_false j status_agent agent_num
                        fi
                fi
                else
                        echo "CET AGENT N'EXISTE PAS OU IL EST DECONNECTE !"
                fi
        done
        cmpt=$((cmpt+1))
done

