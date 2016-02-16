if [[ -n "$PRODUCT" ]]
then
  sed -i.bak "s/REPLACEME/$PRODUCT/g" $JENKINS_HOME/jobs/Management\ Jobs/jobs/backup_jenkins/config.xml
fi
