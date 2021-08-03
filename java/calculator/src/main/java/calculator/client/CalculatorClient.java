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
package calculator.client;

import org.apache.thrift.TException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TProtocolFactory;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;
import org.eclipse.jdt.annotation.NonNull;
import org.eclipse.jdt.annotation.Nullable;

import calculator.gen.CalculatorService;
import calculator.gen.DivideByZeroException;

/**
 * Extension of {@link CalculatorService.Client} implementing
 * {@link AutoCloseable} interface for use in try-with-resources blocks.
 *
 * <pre>
 * {@code
 * try (var client = new CalculatorClient.Builder().build()) {
 * 	client.add(1, 2);
 * }
 * }
 * </pre>
 */
public class CalculatorClient extends CalculatorService.Client implements AutoCloseable {
	/**
	 * {@link TTransport} being tracked via {@link AutoCloseable} implementation.
	 */
	private final @NonNull TTransport transport;

	/**
	 * Constructor wraps to parent and caches {@link TTransport} used by
	 * {@code protocol} parameter.
	 *
	 * As this class implements the {@link AutoCloseable} interface this will also
	 * open the {@link TTransport} used by {@code protocol}.
	 *
	 * @param protocol Thrift protocol to be used.
	 * @throws TTransportExceptions If thrift transport layer could not be opened.
	 * @see CalculatorService.Client#Client(TProtocol)
	 * @see CalculatorClient.Builder
	 */
	private CalculatorClient(final @NonNull TProtocol protocol) throws TTransportException {
		super(protocol);
		transport = protocol.getTransport();
		transport.open();
	}

	@Override
	public void close() {
		this.transport.close();
	}

	/**
	 * Builder for {@link CalculatorClient} with sensible default values.
	 */
	public static class Builder {
		/**
		 * {@link TTransport} to be used by {@link CalculatorClient}.
		 */
		private @Nullable TTransport transport;

		/**
		 * {@link TProtocolFactory} used to actually create protocol required by
		 * {@link CalculatorClient}.
		 */
		private @NonNull TProtocolFactory protocolFactory = new TBinaryProtocol.Factory();

		/**
		 * Sets {@link TTransport} to be used by {@link CalculatorClient}.
		 *
		 * Calling this function will give responsibility of {@code transport} to the
		 * {@link Builder} and in turn to the {@link CalculatorClient}.
		 * {@link CalculatorClient#CalculatorClient(TProtocol)} will open the
		 * {@code transport} so it must not have been opened before.
		 *
		 * @param transport Thrift transport to be used by client.
		 * @return {@code this} object.
		 */
		public @NonNull Builder withTransport(final @NonNull TTransport transport) {
			this.transport = transport;
			return this;
		}

		/**
		 * Sets {@link TProtocolFactory} to be used for creating protocol for
		 * {@link CalculatorClient}.
		 *
		 * @param protocolFactory Thrift protocol factory to create protocol to be used
		 *                        by client.
		 * @return {@code this} object.
		 */
		public @NonNull Builder withProtocolFactory(final @NonNull TProtocolFactory protocolFactory) {
			this.protocolFactory = protocolFactory;
			return this;
		}

		/**
		 * Actually builds {@link CalculatorClient} object.
		 *
		 * @return Client object based on previously set values.
		 * @throws TTransportException if transport could not be opened.
		 * @see CalculatorClient#CalculatorClient(TProtocol)
		 */
		public @NonNull CalculatorClient build() throws TTransportException {
			if (transport == null) {
				transport = new TSocket("127.0.0.1", 9876);
			}
			return new CalculatorClient(protocolFactory.getProtocol(transport));
		}
	}

	/**
	 * Example showing how to use {@link CalculatorClient}.
	 *
	 * @param args Ignored.
	 * @throws TException If communication error with thrift service occurred.
	 */
	public static void main(String[] args) throws TException {
		// Use try-with-resources to automatically close client
		try (CalculatorClient client = new CalculatorClient.Builder().build()) {
			System.out.println("1+2 = " + client.add(1, 2));
			System.out.println("2-1 = " + client.subtract(2, 1));
			System.out.println("2*3 = " + client.multiply(2, 3));
			System.out.println("4/2 = " + client.divide(4, 2));

			try {
				// This should throw an exception
				client.divide(4, 0);
			} catch (DivideByZeroException e) {
				System.out.println("Caught DivideByZeroException");
			}
		}
	}
}
