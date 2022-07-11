# moia-codebuild-container-images

## Overview

This is a selection of container images preinstalled with `goenv` and `nvm` so that you can use any version of Go or NPM you want, or even install multiple versions. Container images in this repository are used in AWS Codebuild.

## Supported Operating Systems

> Container images are automatically rebuilt and published to public ECR repositories daily (8AM)


### linux/amd64

| Operating System             | Public ECR Repo                                                                                 | Tags             |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------- |
| Ubuntu 22.04 (Jammy Jellyfish)   | [public.ecr.aws/moia-oss/codebuild-amd64-ubuntu](https://gallery.ecr.aws/moia-oss/codebuild-amd64-ubuntu)           | 22.04, jammy, latest        |

### linux/arm64

| Operating System             | Public ECR Repo                                                                                 | Tags             |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------- |
| Ubuntu 22.04 (Jammy Jellyfish)   | [public.ecr.aws/moia-oss/codebuild-arm64-ubuntu](https://gallery.ecr.aws/moia-oss/codebuild-arm64-ubuntu)           | 22.04, jammy, latest        |

## Naming convention

Images follow the naming convention as described below:

`public.ecr.aws/moia-oss/codebuild-<platform>-<os>:<version>`

where 
* `platform` is the system architecture e.g. `amd64`
* `os` is the operation system name e.g. `ubuntu`
* `version` is the container image tag e.g. `latest`

## Running containers locally

To run a container locally with the current built-in `Go` and `Node` version use:

```bash
podman run --rm -it public.ecr.aws/moia-oss/codebuild-arm64-ubuntu:latest
```

you can overwrite the default versions and use specific ones by passing the version number as environment variables:

```bash
podman run --rm -it \
    -e GO_VERSION="1.18.3" \
    -e NODE_VERSION="14.20.0" \
    public.ecr.aws/moia-oss/codebuild-arm64-ubuntu:latest
```

## Examples

Cloudformation Example:

```yaml
DeploySomething:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: !Sub "deploy-something"
      ServiceRole: !Ref CodebuildRole
      TimeoutInMinutes: 360
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        ComputeType: BUILD_GENERAL1_MEDIUM
        Image: public.ecr.aws/moia-oss/codebuild-amd64-ubuntu:latest
        Type: LINUX_CONTAINER
        PrivilegedMode: true
        EnvironmentVariables:
          - Name: GO_VERSION
            Value: "1.18.3"
          - Name: NODE_VERSION
            Value: "14.20.0"
            ...
    Source:
        Type: CODEPIPELINE
        BuildSpec: !Sub |
          version: 0.2
          ... 
```

## Contributing

This project welcomes contributions or suggestions of any kind. Please feel free to create an issue to discuss changes or create a Pull Request if you see room for improvement.
