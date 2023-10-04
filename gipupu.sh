# Скрипт скачает все репы в группе в папку с именем этой группы
# Пример команды:
# ./gipupu.sh 11 https://gitlab.com glpat-jaY8Bjhjhu 
#
# GROUPID - id группы
# TOKEN - gitlab токен, минимум с чтением репозитория
# GITLAB_URL - url адрес вашего gitlab

GROUPID=$1
GITLAB_URL=$2
TOKEN=$3

DIR_NAME=$(tr -d " \"\@\'" <<< $(curl -s --header "PRIVATE-TOKEN: $TOKEN" $GITLAB_URL/api/v4/groups/$GROUPID | jq -r ".path"))
mkdir -p $DIR_NAME
cd $DIR_NAME

IDS=$(curl -s --header "PRIVATE-TOKEN: $TOKEN" $GITLAB_URL/api/v4/groups/$GROUPID/subgroups | jq -r ".[].id")

DIR=$(pwd)

for id in $IDS
do
    cd $DIR
    NAME=$(curl -s --header "PRIVATE-TOKEN: $TOKEN" $GITLAB_URL/api/v4/groups/$id | jq -r ".name")
    mkdir -p $NAME
    cd $NAME
    for repo in $(curl -s --header "PRIVATE-TOKEN: $TOKEN" $GITLAB_URL/api/v4/groups/$id | jq -r ".projects[].ssh_url_to_repo"); do git clone $repo; done;
done

for repo in $(curl -s --header "PRIVATE-TOKEN: $TOKEN" $GITLAB_URL/api/v4/groups/$GROUPID | jq -r ".projects[].ssh_url_to_repo")
do
    git clone $repo
done
