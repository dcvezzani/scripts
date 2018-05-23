#!/bin/zsh
# ~/scripts/send-message.sh

# mutt install script: https://gist.githubusercontent.com/dcvezzani/20c0f3c16b0e25a550401baa85264ec3/raw/de991b1857b7573dcb3aa0694ee3f55396d1befa/mutt-install.sh

subject="$1"
arg1="$2"
arg2="$3"
arg3="$4"
arg4="$5"
arg5="$6"
arg6="$7"
arg7="$8"
cc=""

# visitDts="5/25@2pm"
# echo "$visitDate" - "$visitTime"
# exit

# if [[ "$lastname" == "" ]]; then
#   echo Usage: send-message.sh \"Service opportunity\" $HOME/Downloads/my-message.txt Smith --phone=6666666666 --email=someone@gmail.com --dts='5/25@2pm' --ccopy someoneelse@gmail.com,somestranger@gmail.com
#   exit
# fi

unset MYARGS
typeset -A MYARGS
MYARGS=()

key="${arg1%=*}"
value="${arg1##*=}"
MYARGS["$key"]="$value"

key="${arg2%=*}"
value="${arg2##*=}"
MYARGS["$key"]="$value"

key="${arg3%=*}"
value="${arg3##*=}"
MYARGS["$key"]="$value"

key="${arg4%=*}"
value="${arg4##*=}"
MYARGS["$key"]="$value"

key="${arg5%=*}"
value="${arg5##*=}"
MYARGS["$key"]="$value"

key="${arg6%=*}"
value="${arg6##*=}"
MYARGS["$key"]="$value"

key="${arg7%=*}"
value="${arg7##*=}"
MYARGS["$key"]="$value"

# for k in "${(@k)MYARGS}"; do
#   echo "$k -> $MYARGS[$k]"
# done

phone="${MYARGS["--phone"]}"
email="${MYARGS["--email"]}"
visitDts="${MYARGS["--dts"]}"
ccopyAddrs="${MYARGS["--ccopy"]}"
inlineMsg="${MYARGS["--msg"]}"
msgFile="${MYARGS["--file"]}"
lastname="${MYARGS["--lastname"]}"
contactInfo="${MYARGS["--contactInfo"]}"
contactVisits="${MYARGS["--contactVisits"]}"




if [[ "$contactInfo" != "" ]]; then
	contactInfoJson=`curl http://localhost:3000/contact-info\?data\="$contactInfo"`
	# echo "$contactInfoJson"
	xlastname=$(echo `echo "$contactInfoJson" | jq -r '.lastname'`)
	xphone=$(echo `echo "$contactInfoJson" | jq -r '.phone'`)
	xemail=$(echo `echo "$contactInfoJson" | jq -r '.email'`)

	if [[ "$lastname" == "" ]]; then
		lastname="$xlastname"
	fi
	if [[ "$phone" == "" ]]; then
		phone="$xphone"
	fi
	if [[ "$email" == "" ]]; then
		email="$xemail"
	fi
fi

if [[ "$lastname" == "" ]]; then
	echo Error: lastname missing; set --lastname=Smith
  # echo Usage: send-message.sh \"Service opportunity\" $HOME/Downloads/my-message.txt Smith --phone=6666666666 --email=someone@gmail.com --dts='5/25@2pm' --ccopy someoneelse@gmail.com,somestranger@gmail.com
  exit
fi

if [[ "$visitDts" != "" ]]; then
	dateJson=`curl http://localhost:3000/format-time\?dts\="$visitDts"`
	visitDate=$(echo `echo "$dateJson" | jq -r '.date'`)
	visitTime=$(echo `echo "$dateJson" | jq -r '.time'`)
fi

if [[ "$contactVisits" != "" ]]; then
	contactVisitsJson=`curl -X POST http://localhost:3000/contact-visits --data "$lastname=$contactVisits"`
	echo "$contactVisitsJson"
	xvisitDate=$(echo `echo "$contactVisitsJson" | jq -r '.date'`)
	xvisitTime=$(echo `echo "$contactVisitsJson" | jq -r '.time'`)

	if [[ "$visitDate" == "" ]]; then
		visitDate="$xvisitDate"
	fi
	if [[ "$visitTime" == "" ]]; then
		visitTime="$xvisitTime"
	fi
fi

if [[ "$visitDate" == "" ]]; then
	echo Error: visit date missing; set --dts or --contactVisits
	exit
fi

if [[ "$inlineMsg" != "" ]]; then
	msg=$(echo "$inlineMsg" | sed 's#\$lastname#'"$lastname"'#g; s#\$visitDate#'"$visitDate"'#g; s#\$visitTime#'"$visitTime"'#g; ')
elif [[ "$msgFile" != "" ]]; then
	msg=$(sed 's#\$lastname#'"$lastname"'#g; s#\$visitDate#'"$visitDate"'#g; s#\$visitTime#'"$visitTime"'#g; ' "$msgFile")
else
	echo Error: message missing; set --msg or --file
	exit
fi

# echo "$lastname, $phone, $email"

if [[ "$ccopyAddrs" != "" ]]; then
	cc=`curl http://localhost:3000/format-email-addresses\?addresses\="$ccopyAddrs"`
fi

# echo "$msg"
# echo "$phone"
# exit

# ./send-message.sh "Service opportunity" $HOME/Downloads/my-message.txt Vezzani --phone=6666666666 --email=someone@gmail.com

# firstline=$(awk 'NR == 1' "$msgFile")
# echo "$firstline" | grep '^subject: '
#
# # a subject line was provided
# if [[ "$?" == "0" ]]; then
#   subject=$(echo "$firstline" | sed 's/^subject: *\(.*\)$/\1/')
#   echo $subject
# fi

# echo "-s $subject" "$cc" "$email"
# exit

# send text
if [ "$phone" != "" ]; then
  echo "... Sending text: $lastname $phone"
  # osascript "$HOME/scripts/send.scpt" +1"$phone" "$subject$msg"
  osascript "$HOME/scripts/send.scpt" +1"$phone" "$msg"
fi

# send email
if [ "$email" != "" ]; then
  echo "... Sending email: $lastname $email"
  echo "$msg" | mutt -s "$subject" "$cc" "$email"

	if [[ "$?" != "0" ]]; then
		echo "It looks like there were issues using mutt to send email."
		echo "Check https://myaccount.google.com/u/1/lesssecureapps?pageId=none to see if you allow for less secure email clients"
		open "https://myaccount.google.com/u/1/lesssecureapps?pageId=none"
	fi
fi




