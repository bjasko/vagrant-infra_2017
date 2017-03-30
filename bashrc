export LOCAL_IP=192.168.56.201
export SERVER_IP=192.168.56.150
alias ssh="function dossh { echo \"prvo fwknopam LOCAL_IP: \$LOCAL_IP -> SERVER_IP: \$SERVER_IP\"; fwknop -A \"tcp/22\" --use-hmac -a \$LOCAL_
IP -n \$SERVER_IP; /usr/bin/ssh \$@; };  dossh "

