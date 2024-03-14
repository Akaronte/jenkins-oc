FROM jenkins/jenkins:lts-jdk17


ENV LANG=C.UTF-8
ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT=50000
ENV REF=/usr/share/jenkins/ref
ENV JENKINS_VERSION=2.449
ENV JENKINS_UC=https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


USER root
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN apt update && apt install -y apt-transport-https ca-certificates wget curl gnupg2 software-properties-common && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable"

RUN apt-get update && apt install docker-ce -y

RUN wget https://github.com/okd-project/okd/releases/download/4.13.0-0.okd-2023-09-03-082426/openshift-client-linux-4.13.0-0.okd-2023-09-03-082426.tar.gz && tar -xvf openshift-client-linux-4.13.0-0.okd-2023-09-03-082426.tar.gz && mv oc kubectl /usr/local/bin/


# VOLUME [/var/jenkins_home]

USER jenkins
ENTRYPOINT ["/tini", "--"]
CMD ["/usr/local/bin/jenkins.sh"]



