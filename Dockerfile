FROM alpine:3.20

RUN addgroup -S lintergroup && adduser -S linteruser -G lintergroup  \
    && mkdir /linter_workdir && chown -R linteruser:lintergroup /linter_workdir

# NOTE: setting this will allow to catch error if pipe command below fails.
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# NOTE: update to latest secure libcrypto3 version.
RUN apk add --no-cache curl=8.11.0-r2 go=1.22.9-r0 libcrypto3=3.3.2-r1 \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /bin v1.62.0 \
    && apk del curl

WORKDIR /linter_workdir

USER linteruser

HEALTHCHECK --timeout=1s --retries=1 CMD /bin/golangci-lint --version || exit 1

# NOTE: `gci` linter conflicts with `gofumpt`, which I believe have more sense to use than `gci`.
ENTRYPOINT ["/bin/golangci-lint", "run", "--enable-all", \
            "--disable", "execinquery", \
            "--disable", "exportloopref", \
            "--disable", "forbidigo", \
            "--disable", "depguard", \
            "--disable", "testpackage", \
            "--disable", "gci", \
            "--disable", "gomnd"]