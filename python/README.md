# Example Thrift Server and Client

This project offers [Python 3](https://www.python.org) implementations of the [calculator service](https://github.com/kmhsonnenkind/thrift-example) [thrift](https://thrift.apache.org) service.

It can be used as a skeleton for own [Apache thrift](https://thrift.apache.org) projects and shows how to perform common tasks (like setting up the transport and protocol for thrift).

## Examples

### Client

The default `calculator.Client` can be used as a context manager and directly offers the interface of the `calculator` service.

```python
import calculator

# This will also autoconnect to the server
with calculator.Client() as client:
    # This will actually perform an RPC call to the thrift server
    client.add(1, 2)
```

### Server

The default `calculator.Server` can be used similar to a [Python thread](https://docs.python.org/3/library/threading.html#threading.Thread) and performs all tasks in the background.

```python
import calculator

server = calculator.Server()
server.start()
server.join()
```

## Build and Installation

The project uses [setuptools](https://setuptools.readthedocs.io/en/latest) and can be used like any other Python project. As it is using [Python type hints](https://www.python.org/dev/peps/pep-0484/) and [Python format string literals](https://www.python.org/dev/peps/pep-0498/) it requires `Python >= 3.6`.

### Code Generation

This projects offers the concrete client and server implementation of the [example calculator service](https://github.com/kmhsonnenkind/apache-thrift-example). To fully work it is required to generate the code based on its [calculator.thrift](https://github.com/kmhsonnenkind/thrift-example/blob/main/calculator.thrift) file. You can either call the `thrift` generator yourself or use the convenience functionality provided in the main repository (*scripts/make/py.mk* target `generate-code` or utility script *scripts/win/py/generate-code.bat*).

### Tests

The code is unittested using [pytest](https://docs.pytest.org/). The tests can be found in the *tests* directory and triggered either using `pytest` or *setup.py*'s `pytest` target.

```sh
python3 setup.py pytest
```

### Code Analysis

The code follows certain development rules and can be analyzed with the according tools. The project contains configuration files for the tools mentioned here and should pass all analyzes without warnings or errors.

* [pycodestyle](https://pycodestyle.pycqa.org/en/latest/) or [flake8](https://flake8.pycqa.org/en/latest/) are used to check that the source code follows the style guide defined in [pep8](https://www.python.org/dev/peps/pep-0008/).
* [mypy](http://mypy-lang.org/) is used to statically check all used data-types to potential problems.
* [pylint](https://pylint.org/) is used to statically analyze the code for potential bugs and issues.

```sh
python3 -m pycodestyle calculator
python3 -m flake8 calculator
python3 -m mypy calculator
python3 -m pylint calculator
```

### Documentation

[Sphinx](https://www.sphinx-doc.org/) is used to build additional (HTML) documentation for the project. A custom build target `build_sphinx` is added to *setup.py* that will build the HTML based API documentation.

```sh
python3 setup.py build_sphinx
```
