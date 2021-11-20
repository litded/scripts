#!/bin/bash

# Миграция последних тегов docker из aws в gitlab registry (или любой другой)
#./aws-to-gitlab-ecr.sh crm/ui ww/crm-ui

awsname=$1
glname=$2
REGAWS=<id>.dkr.ecr.<location>.amazonaws.com/
REGGL=<registry url>/

aws ecr describe-images --repository-name $awsname  --query 'sort_by(imageDetails,& imagePushedAt)[*].imageTags[0]' > list

# Мигрирует последние 5 образов по дате создания, если вам нужно другое количество, измените tail -?

for i in $(cat list | sed -e 's/[{":, "}]/''/g' | sed '1d' | sed '$ d' | awk '{printf "%s \n", $1}' | tail -5)
do
  docker pull $REGAWS$awsname:$i
  docker tag $REGAWS$awsname:$i $REGGL$glname:$i 
  docker push $REGGL$glname:$i
done

rm list

# Удалит все образы, на ваше усмотрение
yes | docker image prune --all