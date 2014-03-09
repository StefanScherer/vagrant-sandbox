# switch Ubuntu download mirror to German server
sudo sed -i 's,http://us.archive.ubuntu.com/ubuntu/,http://ftp.fau.de/ubuntu/,' /etc/apt/sources.list
sudo sed -i 's,http://security.ubuntu.com/ubuntu,http://ftp.fau.de/ubuntu,' /etc/apt/sources.list
sudo apt-get update -y

# switch to German keyboard layout
sudo sed -i 's/"us"/"de"/g' /etc/default/keyboard
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y console-common
sudo install-keymap de

# set timezone to German timezone
echo "Europe/Berlin" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

# install development: 
sudo apt-get install -y curl git vim

if [ ! -d /vagrant/resources ]
then
  mkdir /vagrant/resources
fi

# install jenkins
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo "deb http://pkg.jenkins-ci.org/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins

# make jenkins available on port 80 in host-only network eth1
sudo iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 80 -j REDIRECT --to-port 8080
ifconfig eth1 | grep "inet addr"  | sed 's/.*inet addr://' | sed "s/ .*/ $HOSTNAME/" >/vagrant/resources/jenkins-host.txt

# retrieve latest version of swarm-client
swarmClientVersion=`curl -s  http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/maven-metadata.xml | grep latest | sed 's/\s*[<>a-z/]//g'`
wget -O /vagrant/resources/swarm-client.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/$swarmClientVersion/swarm-client-$swarmClientVersion-jar-with-dependencies.jar

while [ ! -f jenkins-cli.jar ]
do
    sleep 10
    wget http://localhost:8080/jnlpJars/jenkins-cli.jar
done
set -x
# force read update list
wget -O default.js http://updates.jenkins-ci.org/update-center.json
sed '1d;$d' default.js > default.json
curl -X POST -H "Accept: application/json" -d @default.json http://localhost:8080/updateCenter/byId/default/postBack --verbose

java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin git
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin checkstyle
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin swarm

# restart jenkins to activate all plugins
java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart
