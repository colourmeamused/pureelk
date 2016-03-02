#! /bin/bash

/usr/lib/rabbitmq/bin/rabbitmqctl stop

# stop all processes that are under pureelk folder
ps aux | grep pureelk | grep -v 'grep' | tr -s ' ' | cut -d ' ' -f 2 | xargs kill -9
