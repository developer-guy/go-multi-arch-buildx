# syntax = docker/dockerfile:1.4.0
FROM --platform=${BUILDPLATFORM} golang:1.17.8-alpine AS base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
# https://go.dev/ref/mod#module-cache
RUN --mount=type=cache,target=/go/pkg/mod go mod download

FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

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
