#!/bin/bash
OPENSSL=$(which openssl)

# Set up colours
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput setaf 7 && tput setab 0)
CIPHER_INPUT=$(echo -n $4|tr '[:lower:]' '[:upper:]')
CIPHERS=$(2>&1 openssl ciphers | tr ":" "\n" | tr '[:lower:]' '[:upper:]' > ciphers.txt && cat ciphers.txt)
if [[ "$CIPHERS" =~ "$CIPHER_INPUT" ]]; then
  cipherok=1
else
  echo "Our openssl ($OPENSSL) does not support $CIPHER_INPUT cipher - see ciphers.txt for a list of supported ciphers"
  exit
fi
USAGE="
Enter a host and port number and timeout as arguments e.g. $GREEN $0 $(hostname -f) 443 10 RC4 $RESET 

Or with debug:

Enter a host, port number, timeout , cipher as arguments e.g. $GREEN $0 $(hostname -f) 443 10 RC4 $RESET DEBUG

Current CIPHERS: see ciphers.txt"

if [[ "$5" == "DEBUG" ]]; then
  DEBUG=1
else
  DEBUG=0
fi

if [[ -z $OPENSSL ]]; then
  echo "Make sure openssl is installed, or set the path to openssl version in your PATH"
  exit 1
fi

if [[ -z $1 ]] || [[ -z $2 ]] || [[ -z $3 ]] || [[ -z $4 ]]; then
  echo "$USAGE"
  exit 1
fi

fc=0;sc=0
cipher_count=0

for CIPHER in $CIPHERS
do
  if [[ $CIPHER =~ "$CIPHER_INPUT" ]]; then
    OUTPUT=$(2>&1 echo "Hello World" | timeout $3 2>&1 2>&1 openssl s_client $STARTTLS -cipher $CIPHER -connect $1:$2)
    RET=$?
    RET_COLOUR=""
    let ciphercount=$ciphercount+1
  else
    RET=1
    RET_COLOUR=""
    continue
  fi
  if [[ $RET -eq 0 ]]; then
    RET_COLOUR=$GREEN
  elif [[ $RET -eq 1 ]]; then
    RET_COLOUR=$RED
  else
    RET_COLOUR=$YELLOW
  fi

  # must have cert data or a non NONE Cipher
  if [ $DEBUG -ne 0 ]; then
    echo "OUTPUT=$OUTPUT"
  fi

  MSG_COMMON="on port $YELLOW$2$RESET using $YELLOW$proto$RESET, cipher: $YELLOW$CIPHER$RESET - return code: $RET_COLOUR$RET$RESET"
  if ([[ $RET -eq 0 ]] ) ; then
    let sc=$sc+1
    echo $GREEN"Successfully$RESET connected to $1 $MSG_COMMON"
  else
    let fc=$fc+1
    echo $RED"Failed$RESET to connect $1 $MSG_COMMON"
  fi
  sleep 1
done
if [[ $ciphercount -eq 0 ]]; then
  echo "No ciphers found matching $4"
fi
echo "$RED$fc$RESET failed connections"
echo "$GREEN$sc$RESET successful connections"
