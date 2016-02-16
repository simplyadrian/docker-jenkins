#!/bin/bash
/restore.sh
chown -R jenkins:jenkins /usr/share/jenkins/ref
cp -Rp /usr/share/jenkins/ref/jobs $JENKINS_HOME
cp -Rpn /usr/share/jenkins/ref/jenkins_config.xml $JENKINS_HOME/config.xml
/fixup_backup.sh
. /credstash.sh
groupmod -g $(stat -c "%g" "$JENKINS_HOME") jenkins
usermod -u $(stat -c "%u" "$JENKINS_HOME") jenkins
/usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
exec gosu jenkins /bin/tini -- /usr/local/bin/jenkins.sh "$@"
