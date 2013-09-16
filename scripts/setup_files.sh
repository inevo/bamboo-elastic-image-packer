# setup maven settings
mkdir -p /home/bamboo/.m2
cp /tmp/settings.xml /home/bamboo/.m2
chown -R bamboo /home/bamboo/.m2

# setup ssh keys
mkdir -p /home/bamboo/.ssh
cp /tmp/id_rsa.pub /home/bamboo/.ssh
cp /tmp/id_rsa /home/bamboo/.ssh
chown -R bamboo /home/bamboo/.ssh