pureelk RHEL 7.x port
=====================

Quick and dirty port of the pureelk docker repo to work on RHEL 7.x with yum and systemd.

Not in Docker hub atm. Requires the following steps to build the Docker image:

`
git clone https://github.com/colourmeamused/pureelk.git
docker build -t pureelk-rhel .

`

Now we can follow the standard instructions at http://www.2vcps.com/?p=1923

Change the URL to point to the forked repo, so the curl command becomes:

`curl -s https://raw.githubusercontent.com/colourmeamused/pureelk/master/pureelk.sh | bash -s install`

