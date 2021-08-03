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
namespace java calculator.gen
namespace py calculator
namespace netstd Calculator


/**
 * Exception raised if division by 0 requested.
 */
exception DivideByZeroException {
}


/**
 * Simple service for basic mathematic operations.
 */
service CalculatorService {
    /**
     * Performs addition.
     *
     * @return Sum of both summands.
     */
    i32 add(
        /**
         * First summand for addition.
         */
        1:i32 first,
        /**
         * Second summand for addition.
         */
        2:i32 second
    ),

    /**
     * Performs subtraction.
     *
     * @return Difference of minuend and subtrahend.
     */
    i32 subtract(
        /**
         * Minuend for subtraction.
         */
        1:i32 minuend,
        /**
         * Subtrahend for subtraction.
         */
        2:i32 subtrahend
    ),

    /**
     * Performs multiplication.
     *
     * @return Product of both factors.
     */
    i32 multiply(
        /**
         * First factor for multiplication.
         */
        1:i32 first,
        /**
         * Second factor for multiplication.
         */
        2:i32 second
    ),

    /**
     * Performs division.
     *
     * @return Quotient of integer division of dividend and divisor.
     * @throws DivideByZeroException If divisor is {@code 0}.
     */
    i32 divide(
        /**
         * Dividend for division.
         */
        1:i32 dividend,
        /**
         * Divisor for division.
         */
        2:i32 divisor
    ) throws (1:DivideByZeroException ex)
}
