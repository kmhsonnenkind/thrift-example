# Example Thrift Server and Client

This project offers C# / .NET 5 implementations of the [calculator service](https://github.com/kmhsonnenkind/thrift-example) [thrift](https://thrift.apache.org) service.

It can be used as a skeleton for own [Apache thrift](https://thrift.apache.org) projects and shows how to perform common tasks (like setting up the transport and protocol for thrift).

## Examples

### Client

The default `Calculator.Client.Client` implements the `IDisposable` interface and directly offers the interface of the `calculator` service.

```c#
using Calculator.Client;

// This will also autoconnect to the server
using (var client = new Client.Builder().Build())
{
    // This will actually perform an RPC call to the thrift server
    client.Add(1, 2);
}
```

### Server

The default `Calculator.Server.Server` offers synchronous wrappers to the asynchronous interface and can either be run in the back- or foreground.

```c#
using System;
using Calculator.Server;

var server = new Server.Builder().build();

// Add event for keyboard interrupt to shut down server
Console.CancelKeyPress += (_, __) => server.Stop();

// Actually run server
server.Serve();
```

## Build and Installation

The project uses [dotnet 5.0](https://dotnet.microsoft.com/) and can be used like any other .NET project.

```sh
dotnet build Calculator.sln
```

### Code Generation

This projects offers the concrete client and server implementation of the [example calculator service](https://github.com/kmhsonnenkind/thrift-example). To fully work it is required to generate the code based on its [calculator.thrift](https://github.com/kmhsonnenkind/thrift-example/blob/main/calculator.thrift) file. You can either call the `thrift` generator yourself or use the convenience functionality provided in the main repository (*scripts/make/csharp.mk* target `generate-code` or utility script *scripts/win/csharp/generate-code.bat*).

### Tests

The code is unittested using [xunit](https://xunit.net/). The tests can be found in the *\*.Tests* directories and triggered either using the dotnet `test` command.

```sh
dotnet test Calculator.sln
```
