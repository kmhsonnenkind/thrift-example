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
package calculator;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

import calculator.gen.DivideByZeroException;
import calculator.server.CalculatorHandler;

/**
 * Test cases for default service implementation {@link CalculatorHandler}.
 */
public class CalculatorHandlerTest {
	/**
	 * Tests that {@link CalculatorHandler#add(int, int)} correctly performs
	 * addition.
	 */
	@Test
	@DisplayName("add(1, 2)")
	void add() {
		CalculatorHandler handler = new CalculatorHandler();
		assertEquals(handler.add(1, 2), 3);
	}

	/**
	 * Tests that {@link CalculatorHandler#subtract(int, int)} correctly performs
	 * subtraction.
	 */
	@Test
	@DisplayName("subtract(4, 2)")
	void subtract() {
		CalculatorHandler handler = new CalculatorHandler();
		assertEquals(handler.subtract(4, 2), 2);
	}

	/**
	 * Tests that {@link CalculatorHandler#multiply(int, int)} correctly performs
	 * multiplication.
	 */
	@Test
	@DisplayName("multiply(2, 3)")
	void multiply() {
		CalculatorHandler handler = new CalculatorHandler();
		assertEquals(handler.multiply(2, 3), 6);
	}

	/**
	 * Tests that {@link CalculatorHandler#divide(int, int)} correctly performs
	 * division.
	 */
	@Test
	@DisplayName("divide(8, 4)")
	void divide() throws DivideByZeroException {
		CalculatorHandler handler = new CalculatorHandler();
		assertEquals(handler.divide(8, 4), 2);
	}

	/**
	 * Tests that {@link CalculatorHandler#divide(int, int)} correctly detects
	 * division by 0.
	 */
	@Test
	@DisplayName("divide(1, 0)")
	void divideByZero() {
		CalculatorHandler handler = new CalculatorHandler();
		assertThrows(DivideByZeroException.class, () -> {
			handler.divide(1, 0);
		});
	}
}
