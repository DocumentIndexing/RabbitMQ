#!/bin/sh

COUNTER=0
if [ -z $RABBITMQ_URL ]; then
    RABBITMQ_URL=rabbitMq:15672
fi
printf "waiting for $RABBITMQ_URL   "
until curl --output /dev/null --silent --head --fail $RABBITMQ_URL; do
    printf '.'
    if [ $COUNTER -gt 20 ]; then
        printf "\n waited too long\n"
        exit 2
    fi
    sleep 5
    COUNTER=$COUNTER+1
done
echo "Available"