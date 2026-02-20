FROM alpine:3.23

RUN addgroup -S lintergroup && adduser -S linteruser -G lintergroup  \
    && mkdir /linter_workdir && chown -R linteruser:lintergroup /linter_workdir

# NOTE: setting this will allow to catch error if pipe command below fails.
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk add --no-cache curl=8.17.0-r1 go=1.25.7-r0 \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /bin v2.10.1 \
    && apk del curl

COPY .golangci.yml /.golangci.yml

WORKDIR /linter_workdir

USER linteruser

HEALTHCHECK --timeout=1s --retries=1 CMD /bin/golangci-lint --version || exit 1

# NOTE: `gci` linter conflicts with `gofumpt`, which I believe have more sense to use than `gci`.
# NOTE: `gofumpt` is strange, disabling.
ENTRYPOINT ["/bin/golangci-lint", "run", "--config", "/.golangci.yml", \
            "--enable", "asasalint", \
            "--enable", "asciicheck", \
            "--enable", "bidichk", \
            "--enable", "contextcheck", \
            "--enable", "copyloopvar", \
            "--enable", "cyclop", \
            "--enable", "decorder", \
            "--enable", "dogsled", \
            "--enable", "dupl", \
            "--enable", "embeddedstructfieldcheck", \
            "--enable", "err113", \
            "--enable", "errcheck", \
            "--enable", "errchkjson", \
            "--enable", "errname", \
            "--enable", "errorlint", \
            "--enable", "exhaustive", \
            "--enable", "exhaustruct", \
            "--enable", "exptostd", \
            "--enable", "fatcontext", \
            "--enable", "forcetypeassert", \
            "--enable", "funcorder", \
            "--enable", "funlen", \
            "--enable", "gochecknoglobals", \
            "--enable", "gochecknoinits", \
            "--enable", "gochecksumtype", \
            "--enable", "gocognit", \
            "--enable", "goconst", \
            "--enable", "gocritic", \
            "--enable", "gocyclo", \
            "--enable", "godox", \
            "--enable", "gosmopolitan", \
            "--enable", "govet", \
            "--enable", "grouper", \
            "--enable", "iface", \
            "--enable", "importas", \
            "--enable", "inamedparam", \
            "--enable", "ineffassign", \
            "--enable", "interfacebloat", \
            "--enable", "intrange", \
            "--enable", "iotamixing", \
            "--enable", "lll", \
            "--enable", "maintidx", \
            "--enable", "makezero", \
            "--enable", "mirror", \
            "--enable", "mnd", \
            "--enable", "modernize", \
            "--enable", "nakedret", \
            "--enable", "nestif", \
            "--enable", "nilerr", \
            "--enable", "nilnesserr", \
            "--enable", "nilnil", \
            "--enable", "nlreturn", \
            "--enable", "noctx", \
            "--enable", "noinlineerr", \
            "--enable", "nolintlint", \
            "--enable", "paralleltest", \
            "--enable", "perfsprint", \
            "--enable", "prealloc", \
            "--enable", "predeclared", \
            "--enable", "reassign", \
            "--enable", "sloglint", \
            "--enable", "tagalign", \
            "--enable", "tparallel", \
            "--enable", "unconvert", \
            "--enable", "unparam", \
            "--enable", "unused", \
            "--enable", "usestdlibvars", \
            "--enable", "varnamelen", \
            "--enable", "wastedassign", \
            "--enable", "whitespace", \
            "--enable", "wrapcheck", \
            "--enable", "wsl_v5", \
            "--disable", "forbidigo", \
            "--disable", "tagliatelle", \
            "--disable", "gosec", \
            "--disable", "depguard", \
            "--disable", "testpackage"]
