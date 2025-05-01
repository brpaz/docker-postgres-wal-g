# Contributing

## Pre-requisites

- [Install Docker Engine | Docker Docs](https://docs.docker.com/engine/install/)

## Setup the development environment

This project uses the following development tools:

- [direnv](https://direnv.net/)
- [hadolint/hadolint](https://github.com/hadolint/hadolint) -  Dockerfile linter, validate inline bash, written in Haskell
- [Task](https://taskfile.dev/) - Task is a task runner / build tool that aims to be simpler and easier to use than, for example, GNU Make.
- [GoogleContainerTools/container-structure-test](https://github.com/GoogleContainerTools/container-structure-test) - validate the structure of your container images
- [aquasecurity/trivy](https://github.com/aquasecurity/trivy) - Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more

Trivy and Hadolint are provided via Docker. The rest you must install yourself.

> [!TIP]
> You can also use [Devbox ](https://www.jetify.com/devbox/docs/installing_devbox/) to manage the tools with Nix. Work in progress.

## Getting started

This project includes a `Taskfile.yaml` to run command tasks. run `task -l` to see what´s available.
