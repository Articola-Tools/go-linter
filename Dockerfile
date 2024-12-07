FROM alpine:3.21

RUN addgroup -S lintergroup && adduser -S linteruser -G lintergroup  \
    && mkdir /linter_workdir && chown -R linteruser:lintergroup /linter_workdir

# NOTE: setting this will allow to catch error if pipe command below fails.
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache curl=8.11.0-r2 go=1.22.9-r0 \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /bin v1.62.0 \
    && apk del curl

COPY .golangci.yml /.golangci.yml

WORKDIR /linter_workdir

USER linteruser

HEALTHCHECK --timeout=1s --retries=1 CMD /bin/golangci-lint --version || exit 1

# NOTE: `gci` linter conflicts with `gofumpt`, which I believe have more sense to use than `gci`.
# NOTE: `gofumpt` is strange, disabling.
ENTRYPOINT ["/bin/golangci-lint", "run", "--enable-all", "--config", "/.golangci.yml", \
            "--disable", "exportloopref", \
            "--disable", "forbidigo", \
            "--disable", "depguard", \
            "--disable", "testpackage", \
            "--disable", "gci", \
            "--disable", "gofumpt"]
