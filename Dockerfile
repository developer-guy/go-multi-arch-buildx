# syntax = docker/dockerfile:1.4.2@sha256:443aab4ca21183e069e7d8b2dc68006594f40bddf1b15bbd83f5137bd93e80e2
FROM --platform=${BUILDPLATFORM} golang:1.18-alpine@sha256:7cc62574fcf9c5fb87ad42a9789d5539a6a085971d58ee75dd2ee146cb8a8695 AS base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
# https://go.dev/ref/mod#module-cache
RUN --mount=type=cache,target=/go/pkg/mod go mod download

FROM --platform=$BUILDPLATFORM tonistiigi/xx:1.1.1@sha256:23ca08d120366b31d1d7fad29283181f063b0b43879e1f93c045ca5b548868e9 AS xx

FROM base AS build

COPY --from=xx / /

ARG TARGETPLATFORM
# https://pkg.go.dev/cmd/go#hdr-Build_and_test_caching
RUN --mount=type=bind,target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
  xx-go build -o /out/example .

FROM scratch AS bin-unix
COPY --from=build /out/example /

ENTRYPOINT [ "/example"]
