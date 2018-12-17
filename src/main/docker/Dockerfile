FROM rabbitmq:3-management

COPY maven/etc/rabbitmq /etc/rabbitmq

COPY maven/scripts/* /app/

# TODO PURELY FOR TESTING/DEMO REMOVE!!!
RUN apt-get update && \
    apt-get install -y curl jq

# Define default command
ENTRYPOINT ["/app/init.sh"]
