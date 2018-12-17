#!/bin/bash
resultsSize=40
for subject in chemistry physics bitcoin "self help" banana elephant
do
    echo "downloading $subject"
    for i in {1..100}
    do
       exec curl "https://www.googleapis.com/books/v1/volumes?q=$subject&startIndex=$(($i*$resultsSize))&maxResults=$resultsSize" | \
            jq -c '.items[]' - | \
            jq -c '.volumeInfo' - |  \
            sed 's/\\/\\\\/g' | \
            sed "s/'/ /g" | \
            sed "s/*/ /g" | \
            sed 's/\"/\\\"/g' | \
            xargs -I {} rabbitmqadmin publish exchange=indexDocument \
                                              payload="{}" \
                                              routing_key= \
                                              --vhost=indexing \
                                              --username ${RABBITMQ_DEFAULT_USER} \
                                              --password $(< ${RABBITMQ_DEFAULT_PASS_FILE})
    done
done