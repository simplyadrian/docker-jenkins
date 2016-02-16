if [[ -n "$CLOUDBIND_SECRET" ]] && [[ -n "$ENVIRON" ]] && [[ -n "$CREDSTASH_TABLE" ]]
then
  CLOUDBIND_PASSWORD=$(credstash -t $CREDSTASH_TABLE get -n $CLOUDBIND_SECRET env=$ENVIRON)
  sed -i.bak "s/bindPassword></bindPassword>$CLOUDBIND_PASSWORD</g" $JENKINS_HOME/config.xml
fi
