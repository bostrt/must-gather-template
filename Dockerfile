FROM quay.io/openshift/origin-cli

COPY ./scripts/* /usr/bin/

ENTRYPOINT /usr/bin/gather
