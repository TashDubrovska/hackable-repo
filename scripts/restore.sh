#!/bin/bash -x
USERNAME=""
EMAIL=""

rm ~/.ssh/id_rsa_victim
rm ~/.ssh/id_rsa_victim.pub

mv ~/.ssh/id_rsa__backup ~/.ssh/id_rsa
mv ~/.ssh/id_rsa__backup.pub ~/.ssh/id_rsa.pub

ssh-add ~/.ssh/id_rsa

git config --global user.name $USERNAME
git config --global user.email $EMAIL
