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

namespace Calculator.Server
{
    class Program
    {
        /// <summary>
        /// Example running a thrift server for the <see cref="CalculatorService"/>.
        /// </summary>
        /// <param name="args">ignored</param>
        static void Main(string[] args)
        {
            // Use Builder pattern to create server
            var server = new Server.Builder().Build();

            // Add event for keyboard interrupt to shut down server
            Console.CancelKeyPress += (_, __) => server.Stop();
            Console.WriteLine("Running the CalculatorService (Press CTRL-C to stop)...");

            // Actually run server
            server.Serve();
        }
    }
}

