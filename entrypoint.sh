#!/usr/bin/env bash

if [[ -z "$INPUT_AWS_ACCESS_KEY_ID" ]]
then
    echo "AWS_ACCESS_KEY_ID is missing"
    exit 1
fi

if [[ -z "$INPUT_AWS_SECRET_ACCESS_KEY" ]]
then
    echo "AWS_SECRET_ACCESS_KEY is missing"
    env
    exit 1
fi

if [[ -z "$INPUT_AWS_REGION" ]]
then
    echo "AWS_REGION is missing"
    exit 1
fi

if [[ -z "$INPUT_SERVICE_NAME" ]]
then
    echo "SERVICE_NAME is missing"
    exit 1
fi

if [[ -z "$INPUT_CURRENT_IMAGE" ]]
then
    echo "CURRENT_IMAGE is missing"
    exit 1
fi



## Set AWS credentials
export AWS_ACCESS_KEY_ID="${INPUT_AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${INPUT_AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${INPUT_AWS_REGION}"

## First get the ServiceNames
aws ecs list-services --cluster cluster-pro > result1.txt
for((i=0; i< $(jq ' .[] | length' result1.txt ); i++))
do
	Line=$(cat result1.txt | jq ".serviceArns[$i]")
	if [[ "$Line" == *"${INPUT_SERVICE_NAME}"* ]]
	then
		Line2=$(echo "$Line" | cut -d "\"" -f 2)
  		aws ecs list-tasks --cluster cluster-pro --service-name "$Line2" > result2.txt
  		for((j=0; j < $(jq ' .[] | length' result2.txt ); j++))
  		do
			if [[ "${INPUT_CURRENT_IMAGE}" != $(cat result2.txt | jq ".taskArns[$j]" | cut -d "\"" -f 2) ]]
			then
				 echo "::set-output name=updated_img::true"
				 echo "Needs update"
				exit 0
			fi
  		done

  	fi
done
echo "::set-output name=updated_img::false"
exit 1


