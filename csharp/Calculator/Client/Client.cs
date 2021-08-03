// MIT License
//
// Copyright (c) 2021 Martin Kloesch
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
using System;
using System.Net;
using Thrift;
using Thrift.Transport;
using Thrift.Transport.Client;
using Thrift.Protocol;

namespace Calculator.Client
{
    /// <summary>
    /// Extension of <see cref="CalculatorService.Client"/> implementing <see cref="IDisposable"/> interface for use in <c>using</c> declarations.
    /// Also offers synchronous wrappers to asynchronous functions.
    /// </summary>
    /// <example>
    /// <code>
    /// using (var client = new Calculator.Client.Builder().Build())
    /// {
    ///     client.Add(1, 2);
    /// }
    /// </code>
    /// </example>
    class Client : CalculatorService.Client, IDisposable
    {
        /// <summary>
        /// <see cref="TTransport"/> being tracked via <see cref="IDisposable"/> implementation
        /// </summary>
        private readonly TTransport transport;

        /// <summary>
        /// Constructor wraps to parent and caches <see cref="TTransport"/> used by <c>protocol</c> parameter.
        /// As this class implements the <see cref="IDisposable"/> interfaces this will also open the <see cref="TTransport"/> used by <c>protocol</c>.
        /// </summary>
        /// <param name="protocol">Thrift protocol to be used</param>
        /// <exception cref="TTransportException">If thrift transport layer could not be opened</exception>
        /// <seealso cref="CalculatorService.Client.Client(TProtocol)"/>
        /// <seealso cref="Builder"/>
        private Client(TProtocol protocol) : base(protocol)
        {
            transport = protocol.Transport;
            transport.OpenAsync().Wait();
        }

        /// <summary>
        /// Synchronous wrapper to <see cref="addAsync(int,int)"/>
        /// </summary>
        /// <param name="first">First summand for addition</param>
        /// <param name="second">Second summand for addition</param>
        /// <returns>Sum of both summands</returns>
        /// <seealso cref="addAsync(int,int)"/>
        public int Add(int first, int second)
        {
            return addAsync(first, second).GetAwaiter().GetResult();
        }

        /// <summary>
        /// Synchronous wrapper to <see cref="subtractAsync(int,int)"/>
        /// </summary>
        /// <param name="minuend">Minuend for subtraction</param>
        /// <param name="subtrahend">Subtrahend for subtraction</param>
        /// <returns>Difference of minuend and subtrahend</returns>
        /// <seealso cref="subtractAsync(int,int)"/>
        public int Subtract(int minuend, int subtrahend)
        {
            return subtractAsync(minuend, subtrahend).GetAwaiter().GetResult();
        }

        /// <summary>
        /// Synchronous wrapper to <see cref="multiplyAsync(int,int)"/>
        /// </summary>
        /// <param name="first">First factor for multiplication</param>
        /// <param name="second">Second factor for multiplication</param>
        /// <returns>Product of both factors</returns>
        /// <seealso cref="multiplyAsync(int,int)"/>
        public int Multiply(int first, int second)
        {
            return multiplyAsync(first, second).GetAwaiter().GetResult();
        }

        /// <summary>
        /// Synchronous wrapper to <see cref="divideAsync(int,int)"/>
        /// </summary>
        /// <param name="dividend">Dividend for division</param>
        /// <param name="divisor">Divisor for division</param>
        /// <returns>Quotient of integer division of dividend and divisor</returns>
        /// <exception cref="Calculator.DivideByZeroException">If divisor is <c>0</c></exception>
        /// <seealso cref="divideAsync(int,int)"/>
        public int Divide(int dividend, int second)
        {
            return divideAsync(dividend, second).GetAwaiter().GetResult();
        }

        /// <summary>
        /// Closes the underlying <see cref="TTransport"/> as part of the <see cref="IDisposable"/> implementation.
        /// </summary>
        /// <seealso cref="IDisposable.Dispose()"/>
        public new void Dispose()
        {
            base.Dispose();
            transport.Close();
        }

        /// <summary>
        /// Builder for <see cref="Client"/> with sensible default values.
        /// </summary>
        public class Builder
        {
            /// <summary>
            /// <see cref="TTransport"/> to be used by <see cref="Client"/>.
            /// </summary>
            /// <seealso cref="WithTransport(TServerTransport)"/>
            private TTransport? transport = null;

            /// <summary>
            /// <see cref="TProtocolFactory"/> used to actually create protocol required by <see cref="Client"/>.
            /// </summary>
            /// <seealso cref="WithProtocolFactory(TProtocolFactory)"/>
            private TProtocolFactory protocolFactory = new TBinaryProtocol.Factory();

            /// <summary>
            /// Sets <see cref="TTransport"/> to be used by <see cref="Client"/>.
            /// </summary>
            /// <param name="transport">Thrift transport to be used by client.</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithTransport(TTransport transport)
            {
                this.transport = transport;
                return this;
            }

            /// <summary>
            /// Sets <see cref="TProtocolFactory"/> to be used for creating protocol for <see cref="Client"/>
            /// </summary>
            /// <param name="protocolFactory">Thrift protocol factory to create protocol to be used by client.</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithProtocolFactory(TProtocolFactory protocolFactory)
            {
                this.protocolFactory = protocolFactory;
                return this;
            }

            /// <summary>
            /// Actually builds the <see cref="Client"/> object.
            /// </summary>
            /// <returns>Client based on previously set values</returns>
            /// <seealso cref="Client.Client(TProtocol)"/>
            public Client Build()
            {
                var transport = this.transport ?? new TSocketTransport(IPAddress.Parse("127.0.0.1"), 9876, new TConfiguration());
                var protocol = protocolFactory.GetProtocol(transport);
                return new Client(protocol);
            }
        }
    }
}
