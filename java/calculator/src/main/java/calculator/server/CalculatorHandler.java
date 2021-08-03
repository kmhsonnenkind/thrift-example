/*
 * MIT License
 *
 * Copyright (c) 2021 Martin Kloesch
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
package calculator.server;

import calculator.gen.CalculatorService;
import calculator.gen.DivideByZeroException;

/**
 * Default implementation of {@link CalculatorService.Iface}.
 */
public class CalculatorHandler implements CalculatorService.Iface {
	@Override
	public int add(int first, int second) {
		return first + second;
	}

	@Override
	public int subtract(int minuend, int subtrahend) {
		return minuend - subtrahend;
	}

	@Override
	public int multiply(int first, int second) {
		return first * second;
	}

	@Override
	public int divide(int dividend, int divisor) throws DivideByZeroException {
		if (divisor == 0) {
			throw new DivideByZeroException();
		}
		return dividend / divisor;
	}

}
