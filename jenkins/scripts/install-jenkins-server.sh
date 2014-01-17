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

cat <<'GROOVY' | tee configure-jenkins.groovy
import jenkins.model.*
import hudson.model.*
import hudson.slaves.*
Jenkins.instance.addNode(new DumbSlave("slave1","Windows 2008 R2","C:\\Users\\vagrant","1",Node.Mode.NORMAL,"slave1",new JNLPLauncher(),new RetentionStrategy.Always(),new LinkedList())) 

GROOVY
wget -O /vagrant/resources/swarm-client.jar http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/1.11/swarm-client-1.11-jar-with-dependencies.jar

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

java -jar jenkins-cli.jar -s http://localhost:8080 groovy configure-jenkins.groovy


