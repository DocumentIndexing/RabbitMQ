# RabbitMQ set up for Document Search

This is an extension of the standard **rabbitmq:3-management** image with an
extension that prepares the Queue(s), Exchange(s), and Users on initial startup.


## Example Data for Document Indexing
To get some sample data I have created a simple script `loadDemoBooks.sh`
that downloads a set of Google Books documents and queues them up on an indexing Queue.
This is not expected to be run frequently as you'd need to get a google
licence to run it more frequently.