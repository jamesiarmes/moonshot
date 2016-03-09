# Configuring an AWS account

## CodeDeploy Role

Create a role called CodeDeployRole with the AWSCodeDeployRole policy

```
aws iam create-role --role-name CodeDeployRole --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Sid":"","Effect":"Allow","Principal":{"Service":["codedeploy.amazonaws.com"]},"Action":"sts:AssumeRole"}]}'
aws iam attach-role-policy --role-name CodeDeployRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
```

# Basic Usage

The base class is a subclass of Thor, so you can extend it using all the normal
Thor stuff. Here's a really basic example using all the defaults:

```ruby
#!/usr/bin/env ruby

require 'moonshot'

# Set up Moonshot tooling for our environment.
class MyService < Moonshot::CLI
  self.application_name = 'my-service'
  self.artifact_repository = S3Bucket.new('my-service-builds')
  self.build_mechanism = Script.new('build/script.sh')
  self.deployment_mechanism = CodeDeploy.new(asg: 'AutoScalingGroup')

  desc 'my-custom-function'
  def my_custom_function
    puts "<:3)~~ eek! a mouse!"
  end
end

begin
  MyService.start
rescue => e
  warn "Uncaught exception: #{e.class}: #{e.message}"
  warn "at: #{e.backtrace.first}"
  exit(1)
end
```

This example assumes:
- You have a CloudFormation JSON template in "cloud_formation/my-service.json".
- You have an S3 bucket called "my-service-builds".
- You have a script in "script/build.sh" that will build a tarball output.tar.gz.
- You have a working CodeDeploy setup, including the CodeDeployRole.
- You have some need to display an ASCII mouse to the terminal with your release
  tooling.

If all that is true, you can now deploy your software to a new stack with:
```
$ ./bin/environment create
```

By default, you'll get a development environment named `my-service-dev-giraffe`,
where `giraffe` is your username. If you want to provision test or production
named environment, use:
```
$ ./bin/environment create -n my-service-staging
$ ./bin/environment create -n my-service-production
```

By default, create launches the stack and deploys code. If you want to only
create the stack and not deploy code, use:
```
$ ./bin/environment create --no-deploy
```

If you make changes to your application and want to release a development build
to your stack, run:
```
$ ./bin/environment deploy-code
```

To build a "named build" for releasing through test and production environments,
use:
```
$ ./bin/environment build-version v0.1.0
$ ./bin/environment deploy-version v0.1.0 -n <environment-name>
```

We recommend using a CI system like Jenkins to perform those activities, for
consistency.