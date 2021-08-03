# Apache Thrift Example

## About

This project offers an example [Apache Thrift](https://thrift.apache.org/) service and shows how to implement it in different languages.

It shows how to perform common tasks and can be used as a skeleton for your own thrift projects.

The code was tested using the latest thrift version which at the time of writing is `1.14.2`.

## Supported Languages

At the moment the project offers language bindings for:

* C# / .NET 5.0 (in [csharp/Calculator](https://github.com/kmhsonnenkind/thrift-example/tree/main/csharp/Calculator))
* Java 11 (in [java/calculator](https://github.com/kmhsonnenkind/thrift-example/tree/main/java/calculator))
* Python 3.6 (in [python](https://github.com/kmhsonnenkind/thrift-example/tree/main/python))

Each language implementation offers example code as well as build / test configuration showing how to perform common tasks (like running unittests).


## Build and Run

As with any thrift project the build consists of two steps:

* Use `thrift` to generate the language specific code
* Use the language's build tools to actually build the code

For your convenience utility scripts are provided to show how to perform these steps.

Each language offers either a *Makefile* based build script in [scripts/make](https://github.com/kmhsonnenkind/thrift-example/tree/main/scripts/make) or Batch files in [scripts/win](https://github.com/kmhsonnenkind/thrift-example/tree/main/scripts/win). E.g. for the `Python` implementation you can find the build steps either in [scripts/make/py.mk](https://github.com/kmhsonnenkind/thrift-example/blob/main/scripts/make/py.mk) or [scripts/win/py](https://github.com/kmhsonnenkind/thrift-example/tree/main/scripts/win/py).

All targets from the build scripts are bundled in either the main [Makefile](https://github.com/kmhsonnenkind/thrift-example/blob/main/Makefile) or the corresponding scripts in [scripts/win](https://github.com/kmhsonnenkind/thrift-example/tree/main/scripts/win).

The utility scripts will offer the following targets:

* `generate-code` is used to generate the language specific thrift code.
* `build` is used to build the code using the language's build tools.
* `test` is used to run the unittests using the language's test framework.
* `check` is used to run static code analysis using tools matching the desired language.
* `documentation` is used to create (HTML) documentation using the language's documentation generator.
* `clean` is used to remove all generated, build and cache files.

Further each language will also offer a *client* and *server* implementation to use the thrift service.

As an example you can perform common tasks in Linux using `make`:

```sh
make test
make documentation-py
make server-java
make -f scripts/make/csharp.mk client
```

or on Windows using:
```sh
scripts\win\test.bat
scripts\win\py\documentation.bat
scripts\win\java\server.bat
scripts\win\csharp\client.bat
```

### VS Code

The project is set up for use with [Visual Studio Code](https://code.visualstudio.com/). It offers some utility build and launch configurations in [.vscode](https://github.com/kmhsonnenkind/thrift-example/tree/main/.vscode). For full IDE integration please install the language's tooling in VS Code.

As the project needs some configuration variables a workspace settings file [.vscode/settings.json](https://github.com/kmhsonnenkind/thrift-example/blob/main/.vscode/settings.json) is provided. If you need additional configuration please set them via your user config file.
