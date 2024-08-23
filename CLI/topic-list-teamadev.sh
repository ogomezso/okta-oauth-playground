#!/bin/bash

source ../.env

cat <<EOF > oidc-teamdev.properties
# oidc-teamdev.properties
bootstrap.servers=$CCLOUD_BOOTSTRAP
security.protocol=SASL_SSL

# From Okta: token endpoint
sasl.oauthbearer.token.endpoint.url=$OKTA_TOKEN_ENDPOINT

sasl.login.callback.handler.class=org.apache.kafka.common.security.oauthbearer.secured.OAuthBearerLoginCallbackHandler

sasl.mechanism=OAUTHBEARER

# Client ID and Secret from your Okta Kafka client app
# logicalcluster is your cluster name
# identity pool is your IDP Pool
# scope from your Okta authorization server
sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required \
    clientId='$CCLOUD_OKTA_CLIENTID'\
    clientSecret='$CCLOUD_OKTA_PASSWD' \
    extension_logicalCluster='$CCLOUD_CLUSTERID' \
    extension_identityPoolId='$TEAMADEV_IDP' \
    scope='$TEAMADEV_SCOPE';

client.dns.lookup=use_all_dns_ips
# Best practice for higher availability in Apache Kafka clients prior to 3.0
session.timeout.ms=45000
# Best practice for Kafka producer to prevent data loss
acks=all
EOF

kafka-topics --bootstrap-server $CCLOUD_BOOTSTRAP --command-config oidc-teamdev.properties --list