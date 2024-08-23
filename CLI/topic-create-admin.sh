 #!/bin/bash

kafka-topics --bootstrap-server pkc-l6wr6.europe-west2.gcp.confluent.cloud:9092 --command-config oidc-admin.properties --create --topic anyname-topic