#!/bin/bash

#aws_account_id=aws sts get-caller-identity --query Account --output text
aws_account_id=314053136453
image_name=asmt-1-cmba-image
image_tag=latest
region=eu-central-1

aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $aws_account_id.dkr.ecr.eu-central-1.amazonaws.com
docker build -t $image_name:$image_tag app
docker tag $image_name:$image_tag 314053136453.dkr.ecr.eu-central-1.amazonaws.com/asmt-1-cmba-ecr:latest
#docker tag $image_name:$image_tag $aws_account_id.dkr.ecr.$region.amazonaws.com/$image_name:latest
docker push 314053136453.dkr.ecr.eu-central-1.amazonaws.com/asmt-1-cmba-ecr:latest
#docker push $aws_account_id.dkr.ecr.$region.amazonaws.com./$image_name