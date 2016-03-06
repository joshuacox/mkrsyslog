# mkrsyslog
Make a rsyslog container to ship logs upstream PDQ

### usage

Add your own rsyslog.conf to the base directory here \
(or `make example` will copy rsyslog.conf.example for you) 
then `make run`
That's pretty much it

 1. make run - build and run docker container
 2. make build - just build docker container don't run it
 3. make clean - kill and remove docker container
 4. make enter - execute an interactive bash in docker container
 3. make logs - follow the logs of docker container
