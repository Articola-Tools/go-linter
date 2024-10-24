# Articola Tools' Go linter

[![image size](https://ghcr-badge.egpl.dev/articola-tools/go-linter/size?color=dodgerblue)](https://ghcr-badge.egpl.dev/articola-tools/go-linter/size?color=dodgerblue)

This repo contains Dockerfile with preconfigured [Go linter](https://github.com/golangci/golangci-lint).
This linter is used in Articola Tools organization's repositories to lint Go
code.

## Usage

Use `ghcr.io/articola-tools/go-linter` Docker image with `-v ./:/linter_workdir`
parameter, where `./` - is a path to a folder with files you want to lint.

Example command to use this linter -
`docker run --rm -v ./:/linter_workdir ghcr.io/articola-tools/go-linter`
