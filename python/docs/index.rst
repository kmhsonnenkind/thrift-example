###################################
Example `thrift` Service and Client
###################################

.. toctree::
   :maxdepth: 2
   :caption: Contents:

This library offers an example `thrift <https://thrift.apache.org>`_ server and client for the `calculator service <https://github.com/kmhsonnenkind/thrift-example>`_.

It can be used as a skeleton for own `thrift` projects and shows how to perform common tasks (like setting up the transport and protocol for thrift).

********
Examples
********

Client
======

The default :py:class:`calculator.Client` can be used as a context manager and directly offers the interface of the `calculator service`.

.. code-block:: python

   import calculator

   # This will also autoconnect to the server
   with calculator.Client() as client:
       # This will actually perform an RPC call to the thrift server
       client.add(1, 2)


Server
======

The default :py:class:`calculator.Server` can be used similar to a thread and performs all tasks in the background.

.. code-block:: python

   import calculator

   server = calculator.Server()
   server.start()
   server.join()


**************************
`calculator` Documentation
**************************

.. automodule:: calculator
  :members:
