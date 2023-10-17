# moia-codebuild-container-images

[![pipeline](https://github.com/moia-oss/moia-codebuild-container-images/actions/workflows/pipeline.yml/badge.svg)](https://github.com/moia-oss/moia-codebuild-container-images/actions/workflows/pipeline.yml)

## Overview

This is a selection of container images preinstalled with `goenv` and `n` so that you can use any version of Go or NPM you want, or even install multiple versions. Container images in this repository are used in AWS Codebuild.

## Supported Operating Systems

> Container images are automatically rebuilt and published to public ECR repositories weekly (8AM UTC)

### linux/amd64

| Operating System               | Public ECR Repo                                                                               | Tags                 |
| ------------------------------ | --------------------------------------------------------------------------------------------- | -------------------- |
| Ubuntu 22.04 (Jammy Jellyfish) | [public.ecr.aws/moia-oss/codebuild-ubuntu](https://gallery.ecr.aws/moia-oss/codebuild-ubuntu) | 22.04, jammy, latest |

### linux/arm64

| Operating System               | Public ECR Repo                                                                               | Tags                 |
| ------------------------------ | --------------------------------------------------------------------------------------------- | -------------------- |
| Ubuntu 22.04 (Jammy Jellyfish) | [public.ecr.aws/moia-oss/codebuild-ubuntu](https://gallery.ecr.aws/moia-oss/codebuild-ubuntu) | 22.04, jammy, latest |

## Supported Programming Languages / Runtimes

| Platform                        | Major Versions   | Environment Variable | Default Version |
| ------------------------------- | ---------------- | -------------------- | --------------- |
| Go                              | 1.19, 1.20, 1.21 | `GO_VERSION`         | 1.20            |
| NodeJS                          | 14, 16           | `NODEJS_VERSION`     | 14              |
| Java Development Kit (Corretto) | 11, 17           | `JAVA_VERSION`       | 11              |

### Deprecation Policy

Major versions will be removed without further warning once they have stopped retrieving upstream security updates.

Note that this is fairly aggressive in the case of Go as major versions are only supported for around one year
after release.

### Default Version Selection Policy

We recommend that you pin major versions manually. Default versions will be selected judicially taking into account

- Lambda runtime availability
- Maturity of release

## Naming convention

Images follow the naming convention as described below:

`public.ecr.aws/moia-oss/codebuild-<os>:<version>`

where

- `os` is the operation system name e.g. `ubuntu`
- `version` is the container image tag e.g. `latest`

## Running containers locally

To run a container locally with the current built-in `Go` and `NodeJS` version use:

```bash
podman run --rm -it public.ecr.aws/moia-oss/codebuild-ubuntu:latest
```

you can overwrite the default versions and use specific ones by passing the version number as environment variables:

```bash
podman run --rm -it \
    -e GO_VERSION="1.21" \
    -e NODEJS_VERSION="14" \
    public.ecr.aws/moia-oss/codebuild-ubuntu:latest
```

### Codebuild

AWS Codebuild overrides the `ENTRYPOINT` defined by the dockerfile. This means if you want to use a non-default version
for any language you need to set them yourself. This can be easily done by running the included
`/entrypoint/entrypoint.sh` script, which will respect the environment variables mentioned above.

Alternatively you could call `goenv` and `n` yourself directly.

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
        Image: public.ecr.aws/moia-oss/codebuild-ubuntu:latest
        Type: LINUX_CONTAINER
        PrivilegedMode: true
        EnvironmentVariables:
          - Name: GO_VERSION
            Value: "1.21"
          - Name: NODEJS_VERSION
            Value: "14"
            ...
    Source:
        Type: CODEPIPELINE
        BuildSpec: !Sub |
          version: 0.2
          phases:
            build:
              commands:
                - /entrypoint/entrypoint.sh
                ...
```

CDK TypeScript example:

```typescript
const sourceOutput = new codepipeline.Artifact();
const moiaBuildImageId = 'public.ecr.aws/moia-oss/codebuild-ubuntu:latest';

new codepipeline.Pipeline(this, 'my-pipeline-id', {
  pipelineName: 'my-pipeline',
  stages: [
    {
      stageName: 'ApplicationSource',
      actions: [
        new actions.CodeStarConnectionsSourceAction({
          actionName: 'Source',
          output: sourceOutput,
          owner: 'moia-oss',
          connectionArn: 'arn',
          repo: 'my-repo',
          branch: 'main',
        }),
      ],
    },
    {
      stageName: 'ApplicationBuild',
      actions: [
        new actions.CodeBuildAction({
          actionName: 'Build',
          input: sourceOutput,
          project: new codebuild.Project(this, 'my-codebuild-project', {
            buildSpec: codebuild.BuildSpec.fromSourceFilename('./infrastructure/buildspec-codepipeline.yml'),
            environment: {
              // use LinuxBuildImage if ARM is unwanted
              buildImage: codebuild.LinuxArmBuildImage.fromCodeBuildImageId(moiaBuildImageId),
              environmentVariables: {
                NODEJS_VERSION: {
                  type: codebuild.BuildEnvironmentVariableType.PLAINTEXT,
                  value: '14',
                },
                GO_VERSION: {
                  type: codebuild.BuildEnvironmentVariableType.PLAINTEXT,
                  value: '1.21',
                },
              },
            },
          }),
        }),
      ],
    },
  ],
});
```

## Contributing

This project welcomes contributions or suggestions of any kind. Please feel free to create an issue to discuss changes or create a Pull Request if you see room for improvement.
