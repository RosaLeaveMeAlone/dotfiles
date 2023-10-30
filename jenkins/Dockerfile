FROM jenkins/jenkins:lts-jdk17

USER root
# Install Docker
RUN apt-get update && \
apt-get install -y ca-certificates curl gnupg && \
install -m 0755 -d /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update

RUN apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Compose

RUN apt-get -y install docker-compose-plugin

# Settings

RUN chmod -R 777 /var/jenkins_home
RUN usermod -aG docker jenkins

USER jenkins
# Remember to change owner of the socket
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]