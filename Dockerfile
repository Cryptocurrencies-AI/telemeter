FROM golang:alpine as builder
ENV GOFLAGS="-mod=vendor"
COPY . /go/src/github.com/openshift/telemeter
RUN cd /go/src/github.com/openshift/telemeter && \
    go build ./cmd/telemeter-client && \
    go build ./cmd/telemeter-server && \
    go build ./cmd/authorization-server

FROM golang:alpine
LABEL io.k8s.display-name="Cryptocurrencies Ai fork of OpenShift Telemeter" \
      io.k8s.description="" \
      io.openshift.tags="openshift,monitoring" \
      summary="" \
      maintainer="Alisher A. Khassanov <a.khssnv@gmail.com>"

COPY --from=0 /go/src/github.com/openshift/telemeter/telemeter-client /usr/bin/
COPY --from=0 /go/src/github.com/openshift/telemeter/telemeter-server /usr/bin/
COPY --from=0 /go/src/github.com/openshift/telemeter/authorization-server /usr/bin/
