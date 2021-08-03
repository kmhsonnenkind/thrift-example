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
using Xunit;

namespace Calculator.Server.Tests
{
    /// <summary>
    /// Test cases for default service implementation <see cref="Handler"/>.
    /// </summary>
    public class HandlerTest
    {
        /// <summary>
        /// Tests that <see cref="Handler.addAsync(int,int)"/> correctly performs addition
        /// </summary>
        [Fact]
        public async void TestAdd()
        {
            var handler = new Handler();
            var result = await handler.addAsync(1, 2);
            Assert.Equal(3, result);
        }

        /// <summary>
        /// Tests that <see cref="Handler.subtractAsync(int,int)"/> correctly performs subtraction
        /// </summary>
        [Fact]
        public async void TestSubtract()
        {
            var handler = new Handler();
            var result = await handler.subtractAsync(4, 2);
            Assert.Equal(2, result);
        }

        /// <summary>
        /// Tests that <see cref="Handler.multiplyAsync(int,int)"/> correctly performs multiplication
        /// </summary>
        [Fact]
        public async void TestMultiply()
        {
            var handler = new Handler();
            var result = await handler.multiplyAsync(2, 3);
            Assert.Equal(6, result);
        }

        /// <summary>
        /// Tests that <see cref="Handler.divideAsync(int,int)"/> correctly performs division
        /// </summary>
        [Fact]
        public async void TestDivide()
        {
            var handler = new Handler();
            var result = await handler.divideAsync(8, 4);
            Assert.Equal(2, result);
        }

        /// <summary>
        /// Tests that <see cref="Handler.divideAsync(int,int)"/> correctly detects division by 0.
        /// </summary>
        [Fact]
        public void TestDivideBy0()
        {
            var handler = new Handler();
            Assert.ThrowsAsync<DivideByZeroException>(() => handler.divideAsync(1, 0));
        }
    }
}
