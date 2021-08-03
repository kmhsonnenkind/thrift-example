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
Example implementation of a client for a thrift service.
'''
__all__ = ['Client']


from thrift.transport import TTransport
from thrift.transport import TSocket
from thrift.protocol import TProtocol
from thrift.protocol import TBinaryProtocol

from calculator.gen.calculator import CalculatorService
from calculator.gen.calculator.ttypes import DivideByZeroException


class Client(CalculatorService.Client):
    '''
    Extension of :class:`CalculatorService.Client` with configurable
    transport and protocol that is usable as a context manager.

    .. code-block:: python

        with Client() as client:
            client.add(1, 2)

    '''

    def __init__(self,
                 transport: TTransport.TTransportBase = None,
                 protocol: TProtocol.TProtocolBase = None):
        '''
        Constructor (optionally) sets up transport as well as protocol
        and then wraps to parent.

        :param transport: Thrift transport layer to be used.
            If omitted transport will be created dynamically using
            :meth:`Client._default_transport`.
        :type transport: TTransport.TTransportBase
        :param protocol: Thrift protocol layer to be used.
            If omitted protocol will be created dynamically using
            :meth:`Client._default_protocol`.
        :type protocol: TProtocol.TProtocolBase
        '''
        # Use given transport or use default implementation
        if not transport:
            transport = self._default_transport()
        self._transport = transport

        # Use given protocol or use default implementation
        if not protocol:
            protocol = self._default_protocol(transport)

        # Create client to service
        super().__init__(protocol)

    def __enter__(self):
        '''
        Wraps to :meth:`Client.open` to be usable as context manager.
        '''
        self.open()
        return self

    def __exit__(self, *_):
        '''
        Wraps to :meth:`Client.close` to be usable as context manager.
        '''
        self.close()

    def open(self):
        '''
        Opens transport channel to service.

        Alternatively you can also use this object as a context manager
        in a `with` statement.

        :see: :meth:`TTransport.open`
        '''
        self._transport.open()

    def close(self):
        '''
        Closes transport channel to service.

        Alternatively you can also use this object as a context manager
        in a `with` statement.

        :see: :meth:`TTransport.close`
        '''
        self._transport.close()

    # pylint: disable=no-self-use
    def _default_transport(self) -> TTransport.TTransportBase:
        '''
        Creates default thrift transport layer.

        :return: Default transport layer to be used.
        :rtype: TTransport.TTransportBase
        '''
        transport = TSocket.TSocket('127.0.0.1', 9876)
        transport = TTransport.TBufferedTransport(transport)
        return transport

    # pylint: disable=no-self-use
    def _default_protocol(self, transport: TTransport.TTransportBase) \
            -> TProtocol.TProtocolBase:
        '''
        Creates default thrift protocol layer.

        :param transport: Transport to build protocol on top of.
        :type transport: TTransport.TTransportBase
        :return: Default protocol layer to be used.
        :rtype: TProtocol.TProtocolBase
        '''
        protocol = TBinaryProtocol.TBinaryProtocol(transport)
        return protocol


def main():
    '''
    Main function running example thrift client
    '''
    # Create client and autoconnect using with statement
    with Client() as client:
        print(f'1+2 = {client.add(1,2)}')
        print(f'2-1 = {client.subtract(2,1)}')
        print(f'2*3 = {client.multiply(2,3)}')
        print(f'4/2 = {client.divide(4,2)}')

        try:
            # This should throw an exception
            client.divide(4, 0)
        except DivideByZeroException:
            print('Caught DivideByZeroException')


if __name__ == '__main__':
    main()
