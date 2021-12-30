FROM golang:1.17.5-alpine

RUN apk add --update --no-cache \
  git \
  ca-certificates \
  tzdata \
  curl \
  g++ \
  protobuf \
  && update-ca-certificates

# Prepare Mage
ENV MAGE_VERSION v1.11.0
RUN git clone -b ${MAGE_VERSION} --depth 1 https://github.com/magefile/mage /tmp/mage && \
  cd /tmp/mage && \
  go run bootstrap.go && \
  rm -fR /tmp/mage

# Install Linter
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.38.0

# Prepare latest for protobuf
ENV PROTOC_GEN_GO_VERSION v1.5.1
RUN go get -d -u github.com/golang/protobuf/protoc-gen-go@${PROTOC_GEN_GO_VERSION}
RUN go install github.com/golang/protobuf/protoc-gen-go@${PROTOC_GEN_GO_VERSION}
