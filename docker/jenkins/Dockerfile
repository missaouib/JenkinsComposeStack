FROM jenkins/jenkins:2.501-jdk21

# Disable the setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Pre-install necessary plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Set up JCasC environment variable
ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs/jenkins.yml

# Define Docker CLI version
ARG DOCKER_CLI_VERSION="5:28.0.1-1~debian.12~bookworm"

# Switch to root to install packages
USER root

# Install Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends lsb-release \
    && curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
       https://download.docker.com/linux/debian/gpg \
    && chmod 644 /usr/share/keyrings/docker-archive-keyring.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
       https://download.docker.com/linux/debian bookworm stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends docker-ce-cli=$DOCKER_CLI_VERSION \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -fs /usr/share/zoneinfo/Australia/Sydney /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Switch back to jenkins user
USER jenkins
