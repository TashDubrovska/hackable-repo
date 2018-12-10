#!/bin/bash -x
PUBLIC_KEY=""
USERNAME=""
EMAIL=""

mv ~/.ssh/id_rsa ~/.ssh/id_rsa__backup
mv ~/.ssh/id_rsa.pub ~/.ssh/id_rsa__backup.pub

cat > ~/.ssh/id_rsa_victim <<- EOM

EOM
chmod 700 ~/.ssh/id_rsa_victim

echo $PUBLIC_KEY > ~/.ssh/id_rsa_victim.pub

ssh-add ~/.ssh/id_rsa_victim

git config --global user.name $USERNAME
git config --global user.email $EMAIL
