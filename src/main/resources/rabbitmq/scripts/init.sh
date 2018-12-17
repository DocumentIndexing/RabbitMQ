#!/bin/bash

# Create Rabbitmq user

    (
        /app/waitForRabbitMQ.sh
        echo "waiting 2 seconds for the server to be started"
        sleep 2 ; \

        rabbitmqctl add_vhost indexing  ;\
        rabbitmqctl set_permissions -p indexing ${RABBITMQ_DEFAULT_USER} ".*" ".*" ".*"  ;\

        rabbitmqadmin declare exchange name=indexDocument --vhost=indexing type=direct --username ${RABBITMQ_DEFAULT_USER} --password $(< ${RABBITMQ_DEFAULT_PASS_FILE});\
        rabbitmqadmin declare queue name=indexDocument durable=false --vhost=indexing --username ${RABBITMQ_DEFAULT_USER} --password $(< ${RABBITMQ_DEFAULT_PASS_FILE});\
        rabbitmqadmin declare binding source=indexDocument destination_type="queue" destination=indexDocument  --vhost=indexing --username ${RABBITMQ_DEFAULT_USER} --password $(< ${RABBITMQ_DEFAULT_PASS_FILE}) ;\

        echo "Adding User ${RECEIVER_USER} as receiver";\
        rabbitmqctl add_user $RECEIVER_USER $(< ${RECEIVER_PASS_FILE}) ; \
        rabbitmqctl set_user_tags $RECEIVER_USER administrator ; \
        rabbitmqctl set_permissions -p indexing $RECEIVER_USER  "" "" "indexDocument"  ; \

        echo "Adding User ${PUBLISHER_USER} as publisher";\
        rabbitmqctl add_user $PUBLISHER_USER $(< ${PUBLISHER_PASS_FILE})  ; \
        rabbitmqctl set_user_tags $PUBLISHER_USER administrator ; \
        rabbitmqctl set_permissions -p indexing $PUBLISHER_USER  "" "indexDocument" ""   ; \

        echo "Removing the permissions" ;\

    ) &
#        rabbitmqctl set_permissions -p indexing ${RABBITMQ_DEFAULT_USER} "" "" ""  ;\
# $@ is used to pass arguments to the rabbitmq-server command.
# For example if you use it like this: docker run -d rabbitmq arg1 arg2,
# it will be as you run in the container rabbitmq-server arg1 arg2
/docker-entrypoint.sh rabbitmq-server $@