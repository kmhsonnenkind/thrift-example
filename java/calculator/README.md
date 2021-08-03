# Example Thrift Server and Client

This project offers Java implementations of the [calculator service](https://github.com/kmhsonnenkind/thrift-example) [thrift](https://thrift.apache.org) service.

It can be used as a skeleton for own [Apache thrift](https://thrift.apache.org) projects and shows how to perform common tasks (like setting up the transport and protocol for thrift).

## Examples

### Client

The default `calculator.client.CalculatorClient` implements the `AutoCloseable` interface and directly offers the interface of the `calculator` service.

```java
import calculator.client.CalculatorClient;

// This will also autoconnect to the server
try (var client = new CalculatorClient.Builder().build()) {
    // This will actually perform an RPC call to the thrift server
    client.add(1, 2);
}
```

### Server

The default `calculator.server.CalculatorServer` can be used similar to a `Java Thread` and performs all tasks in the background.

```java
import calculator.server.CalculatorServer;

var server = new CalculatorServer.TSimpleServerBuilder().build();
server.start();
server.join();
```

## Build and Installation

The project uses [gradle](https://gradle.org/) and can be used like any other project. It provides a `gradlew` file that can be used to automatically select the correct version.

```sh
./gradlew build
```

### Code Generation

This projects offers the concrete client and server implementation of the [example calculator service](https://github.com/kmhsonnenkind/apache-thrift-example). To fully work it is required to generate the code based on its [calculator.thrift](https://github.com/kmhsonnenkind/thrift-example/blob/main/calculator.thrift) file. You can either call the `thrift` generator yourself or use the convenience functionality provided in the main repository (*scripts/make/java.mk* target `generate-code` or utility script *scripts/win/java/generate-code.bat*).

### Tests

The code is unittested using [junit 5](https://junit.org/junit5/docs/current/user-guide/). The tests can be found in the *src/tests* directory and triggered either using the `test` gradle target.

```sh
./gradlew test
```

### Code Analysis

The code follows certain development rules and can be analyzed with the according tools. The project contains configuration files for the tools mentioned here and should pass all analyzes without warnings or errors.

* [checkstyle](https://checkstyle.sourceforge.io/) is used to check that the source code follows the style guide and performs additional static code analysis.
* [spotbugs](https://spotbugs.github.io/) is used to statically analyze the code for potential bugs and issues.

The checks can be run using the `check` gradle target.

```sh
./gradlew check
```

### Documentation

[Javadoc](https://en.wikipedia.org/wiki/Javadoc) is used to build additional (HTML) documentation for the project. A build target `javadoc` is available via the gradle wrapper that will build the HTML based API documentation.

```sh
./gradlew javadoc
```
