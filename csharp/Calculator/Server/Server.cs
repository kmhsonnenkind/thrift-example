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
using System.Threading;
using System.Threading.Tasks;
using Thrift;
using Thrift.Protocol;
using Thrift.Server;
using Thrift.Transport;
using Thrift.Transport.Server;

namespace Calculator.Server
{
    /// <summary>
    /// Wrapper around <see cref="TServer"/> offering synchronous interface and possibility to stop the server.
    /// </summary>
    /// <example>
    /// <code>
    /// var server = new Server.Builder().Build();
    /// Console.CancelKeyPress += (_, __) => server.Stop();
    /// server.Serve();
    /// </code>
    /// </example>
    class Server
    {
        /// <summary>
        /// <see cref="TServer"/> dispatching requests.
        /// </summary>
        private readonly TServer server;

        /// <summary>
        /// <see cref="CancellationTokenSource"/> to stop the server.
        /// </summary>
        private readonly CancellationTokenSource cancellationSource;

        /// <summary>
        /// Constructor stores parameters to members.
        /// </summary>
        /// <param name="server">TServer dispatching requests</param>
        /// <param name="cancellationSource">Optional CancellationTokenSource to stop the server</param>
        private Server(TServer server, CancellationTokenSource? cancellationSource = null)
        {
            this.server = server;
            this.cancellationSource = cancellationSource ?? new CancellationTokenSource();
        }

        /// <summary>
        /// Starts the server in the background and returns immediately.
        /// Stop using <see cref="Stop()"/>.
        /// Wait for completion using <see cref="Join()"/>.
        /// </summary>
        /// <returns>Started server task</returns>
        /// <seealso cref="TServer.ServeAsync(CancellationToken)"/>.
        /// <seealso cref="Serve()"/>
        public Task Start()
        {
            return server.ServeAsync(cancellationSource.Token);
        }

        /// <summary>
        /// Stops the running server by requesting cancellation.
        /// </summary>
        public void Stop()
        {
            cancellationSource.Cancel();
            server.Stop();
        }

        /// <summary>
        /// Waits for the server to shut down.
        /// </summary>
        public void Join()
        {
            WaitHandle.WaitAny(new[] { cancellationSource.Token.WaitHandle });
        }

        /// <summary>
        /// Starts the server and waits for it to shut down (e.g. using <see cref="Stop()"/>).
        /// </summary>
        public void Serve()
        {
            Start();
            Join();
        }

        /// <summary>
        /// Builder class for <see cref="Server"/>.
        /// </summary>
        public class Builder
        {
            /// <summary>
            /// <see cref="TServerTransport"/> to be used by server.
            /// </summary>
            /// <seealso cref="WithTransport(TTransport)"/>
            private TServerTransport? transport = null;

            /// <summary>
            /// <see cref="CalculatorService.IAsync"/> implementation to be used by server.
            /// </summary>
            /// <seealso cref="WithHandler(CalculatorService.IAsync)"/>
            private CalculatorService.IAsync? handler = null;

            /// <summary>
            /// <see cref="TTransportFactory"/> to be used by server.
            /// </summary>
            /// <seealso cref="WithTransportFactory(TTransportFactory)"/>
            private TTransportFactory? transportFactory = null;

            /// <summary>
            /// <see cref="TProtocolFactory"/> to be used by server.
            /// </summary>
            /// <seealso cref="WithProtocolFactory(TProtocolFactory)"/>
            private TProtocolFactory? protocolFactory = null;

            /// <summary>
            /// Sets <see cref="TServerTransport"/> to be used by server.
            /// </summary>
            /// <param name="transport">Transport to be used by server</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithTransport(TServerTransport transport)
            {
                this.transport = transport;
                return this;
            }

            /// <summary>
            /// Sets <see cref="CalculatorService.IAsync"/> implementation to be used by server.
            /// </summary>
            /// <param name="handler">Handler to be used by server</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithHandler(CalculatorService.IAsync handler)
            {
                this.handler = handler;
                return this;
            }

            /// <summary>
            /// Sets <see cref="TTransportFactory"/> to be used by server.
            /// </summary>
            /// <param name="transportFactory">TTransportFactory to be used by server</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithTransportFactory(TTransportFactory transportFactory)
            {
                this.transportFactory = transportFactory;
                return this;
            }

            /// <summary>
            /// Sets <see cref="TProtocolFactory"/> to be used by server.
            /// </summary>
            /// <param name="protocolFactory">TProtocolFactory to be used by server</param>
            /// <returns><c>this</c> object</returns>
            public Builder WithProtocolFactory(TProtocolFactory protocolFactory)
            {
                this.protocolFactory = protocolFactory;
                return this;
            }

            /// <summary>
            /// Actually builds the <see cref="Server"/> based on previously set values.
            /// </summary>
            /// <returns>Server based on previously set values</returns>
            /// <seealso cref="Server.Server(TServer, CancellationTokenSource?)"/>
            public Server Build()
            {
                var transport = this.transport ?? new TServerSocketTransport(9876, new TConfiguration());
                var transportFactory = this.transportFactory ?? new TBufferedTransport.Factory();
                var protocolFactory = this.protocolFactory ?? new TBinaryProtocol.Factory();
                var handler = this.handler ?? new Handler();
                var processor = new CalculatorService.AsyncProcessor(handler);
                var server = new TThreadPoolAsyncServer(processor, transport, transportFactory, protocolFactory);
                return new Server(server);
            }
        }
    }
}
