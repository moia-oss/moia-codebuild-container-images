# moia-codebuild-container-images

## Overview

This is a selection of container images preinstalled with `goenv` and `nvm` so that you can use any version of Go or NPM you want, or even install multiple versions. Container images in this repository are used in AWS Codebuild.

## Supported Operating Systems

> Container images are automatically rebuilt and published to public ECR repositories daily (8AM)


### linux/amd64

| Operating System             | Docker Hub Repo                                                                                 | Docker Hub Tags             |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------- |
| Ubuntu 22.04 (Jammy Jellyfish)   | [public.ecr.aws/moia-oss/codebuild-amd64-ubuntu](.)           | 22.04, jammy, latest        |

### linux/arm64

| Operating System             | Docker Hub Repo                                                                                 | Docker Hub Tags             |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------- |
| Ubuntu 22.04 (Jammy Jellyfish)   | [public.ecr.aws/moia-oss/codebuild-arm64-ubuntu](.)           | 22.04, jammy, latest        |

## Naming convention

Images follow the naming convention as described below:

`public.ecr.aws/moia-oss/codebuild-<platform>-<os>:<version>`

where 
* `platform` is the system architecture e.g. `amd64`
* `os` is the operation system name e.g. `ubuntu`
* `version` is the container image tag e.g. `latest`

## Contributing

This project welcomes contributions or suggestions of any kind. Please feel free to create an issue to discuss changes or create a Pull Request if you see room for improvement.
