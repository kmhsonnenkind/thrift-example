# MIT License
#
# Copyright (c) 2021 Martin Kloesch
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

'''
Example implementation of a thrift service for a calculator.
'''

__all__ = ['Server']


import threading

from thrift.transport import TTransport
from thrift.transport import TSocket
from thrift.protocol import TProtocol
from thrift.protocol import TBinaryProtocol
from thrift.server import TServer

from calculator.handler import Handler

from calculator.gen.calculator import CalculatorService


class Server:
    '''
    Example implementation of a thrift server for the `CalculatorService`.

    Offers sensible default values but has fully configurable options
    for both the thrift transport as well as the protocol layer.

    Can be used similar to a thread by offering the methods:

        * :meth:`Server.start`
        * :meth:`Server.stop` and
        * :meth:`Server.join`

    .. code-block:: python

        server = Server()
        try:
            server.start()
            server.join()
        except (KeyboardInterrupt, SystemExit):
            server.stop()

    '''

    def __init__(self,
                 handler: CalculatorService.Iface = None,
                 transport: TTransport.TTransportBase = None,
                 transport_factory: TTransport.TTransportFactoryBase = None,
                 protocol_factory: TProtocol.TProtocolFactory = None):
        '''
        Constructor (optionally) sets up transport as well as protocol
        factories and then wraps to parent.

        :param handler: CalculatorService implementation to be used.
            If omitted this will be created dynamically using
            :meth:`Server._default_handler`.
        :type handler: CalculatorService.Iface
        :param transport: Thrift transport layer to be used.
            If omitted transport will be created dynamically using
            :meth:`Server._default_transport`.
        :type: TTransport.TTransportBase
        :param transport_factory: Thrift transport factory to be used.
            If omitted this will be created dynamically using
            :meth:`Server._default_transport_factory`.
        :type: TTransport.TTransportFactoryBase
        :param protocol_factory: Thrift protocol factory to be used.
            If omitted this will be created dynamically using
            :meth:`Server._default_protocol_factory`.
        :type: TProtocol.TProtocolFactory
        '''
        # Use given handler or use default implementation
        if not handler:
            handler = self._default_handler()

        # Use given transport or use default implementation
        if not transport:
            transport = self._default_transport()
        self._transport = transport

        # Use given transport factory or use default implementation
        if not transport_factory:
            transport_factory = self._default_transport_factory()

        # Use given protocol factory or use default implementation
        if not protocol_factory:
            protocol_factory = self._default_protocol_factory()

        # Actually create server
        self._server = self._create_server(
            CalculatorService.Processor(handler),
            transport,
            transport_factory,
            protocol_factory
        )

        # Prepare server thread
        self._server_thread = None

    def start(self):
        '''
        Starts the server in a background thread.
        '''
        self._server_thread = threading.Thread(target=self._server.serve)
        self._server_thread.start()

    def stop(self):
        '''
        Signals the server to stop (but does not wait for it to
        actually stop).
        '''
        # Close underlying server transport channel
        self._transport.close()

        # Wait for server to shut down
        if self._server_thread:
            self._server_thread.join()
            self._server_thread = None

    def join(self):
        '''
        Waits for the server to shut down.
        '''
        if self._server_thread:
            self._server_thread.join()

    # pylint: disable=no-self-use
    def _create_server(self,
                       processor: CalculatorService.Processor,
                       transport: TTransport.TTransportBase,
                       transport_factory: TTransport.TTransportFactoryBase,
                       protocol_factory: TProtocol.TProtocolFactory
                       ) -> TServer:
        '''
        Creates thrift server based on given input parameters.

        :param processor: Thrift interface processor to be used.
        :type processor: CalculatorService.Processor
        :param transport: Thrift transport layer to be used.
        :type transport: TTransport.TTransportBase
        :param transport_factory: Thrift transport factory to be used.
        :type transport_factory:  TTransport.TTransportFactoryBase
        :param protocol_factory: Thrift protocol factory to be used.
        :type protocol_factory: TProtocol.TProtocolFactory
        :return: Thrift server bases on input parameters.
        :rtype: TServer
        '''
        server = TServer.TSimpleServer(
            processor,
            transport,
            transport_factory,
            protocol_factory
        )
        return server

    # pylint: disable=no-self-use
    def _default_handler(self) -> CalculatorService.Iface:
        '''
        Creates default interface implementation.

        :return: Default interface implementation to be used.
        '''
        handler = Handler()
        return handler

    # pylint: disable=no-self-use
    def _default_transport(self) -> TTransport.TTransportBase:
        '''
        Creates default thrift transport layer.

        :return: Default transport layer to be used.
        '''
        transport = TSocket.TServerSocket('127.0.0.1', 9876)
        return transport

    # pylint: disable=no-self-use
    def _default_transport_factory(self) -> TTransport.TTransportFactoryBase:
        '''
        Creates default thrift transport factory.

        :return: Default transport factory to be used.
        '''
        transport_factory = TTransport.TBufferedTransportFactory()
        return transport_factory

    # pylint: disable=no-self-use
    def _default_protocol_factory(self) -> TProtocol.TProtocolFactory:
        '''
        Creates default thrift protocol factory.

        :return: Default protocol factory to be used.
        '''
        protocol_factory = TBinaryProtocol.TBinaryProtocolFactory()
        return protocol_factory


def main():
    '''
    Main function running example thrift server
    '''
    # Create server
    server = Server()

    # Actually run the server
    try:
        print('Running the CalculatorService ', end=None)
        print('Press CTRL-C or CTRL-Break to stop)...')
        server.start()
        server.join()
    except (KeyboardInterrupt, SystemExit):
        server.stop()


if __name__ == '__main__':
    main()
