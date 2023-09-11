# AWS API Demo using Golang and Terraform
Demo Application for AWS API Gateway using Golang and Terraform


## Requirements

### Environment
* Golang 1.20
* Terraform 1.x
* AWS SAM (for local invocation and debugging only)
* Docker

### Local Setup

#### Golang Setup

Follow the [official documentation](https://go.dev/doc/install) to install Go on your machine.

If you are using Linux you should use your package manager.

Example Fedora:
```shell
sudo dnf install golang
```

#### Install Debugger

If you want to use a debugger during development then install following the [official documentation](https://github.com/go-delve/delve/tree/master/Documentation/installation).

Then create a run configuration in Goland: Edit configurations -> + -> Go Remote -> Port: 5858

Installation example for Linux:
```shell
go install github.com/go-delve/delve/cmd/dlv@master
```

then add to .bashrc:
```shell
export PATH="$HOME/go/bin:$PATH"
```

#### Debug Application

Everything you need to invoke a function with an active debugger can be found in the makefile. Look for targets starting
with *debug-*.

Example:

```shell
make debug-AddItemFunction
```

This will start the function and wait until a debugger is connected.

### Resources

## Q & A

### Why AWS SAM?
AWS SAM is needed for local invocation in order to debug each Lambda function

### Why not use Terraform Workspaces?
todo