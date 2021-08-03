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

import org.apache.thrift.TException;
import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TServer.Args;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;
import org.apache.thrift.transport.TServerTransport;
import org.apache.thrift.transport.TTransportException;
import org.eclipse.jdt.annotation.NonNull;
import org.eclipse.jdt.annotation.Nullable;

import calculator.gen.CalculatorService;
import calculator.gen.CalculatorService.Iface;
import calculator.gen.CalculatorService.Processor;

/**
 * Example server exposing actual {@link TServer} via thread-like interface.
 *
 * <pre>
 * {
 * {@code
 * 	var server = new CalculatorServer.TSimpleServerBuilder().build();
 * 	server.start();
 * 	server.join();
 * }
 * </pre>
 */
public class CalculatorServer {
	/**
	 * {@link Thread} running the server.
	 */
	private final @NonNull Thread backgroundThread;

	/**
	 * Actual {@link TServer} dispatching requests.
	 */
	private final @NonNull TServer server;

	/**
	 * {@link TServerTransport} for data transport over "the-wire".
	 */
	private final @NonNull TServerTransport transport;

	/**
	 * Constructor only stores parameters to members.
	 *
	 * @param server    Actual {@link TServer} dispatching requests.
	 * @param transport Underlying {@link TServerTransport} to be closable.
	 * @see CalculatorServer.Builder
	 */
	private CalculatorServer(@NonNull TServer server, @NonNull TServerTransport transport) {
		// Cache parameters
		this.transport = transport;
		this.server = server;

		// Prepare background thread
		backgroundThread = new Thread(server::serve);
	}

	/**
	 * Starts the server thread in the background.
	 *
	 * @see Thread#start()
	 */
	public void start() {
		backgroundThread.start();
	}

	/**
	 * Waits for the server thread to finish.
	 *
	 * @throws InterruptedException If the current thread gets interrupted.
	 * @see Thread#join()
	 */
	public void join() throws InterruptedException {
		backgroundThread.join();
	}

	/**
	 * Gracefully stop the server thread and wait for it to shut down.
	 */
	public void stop() {
		// Stop server and underlying transport
		server.stop();
		transport.close();

		// Wait for server to shut down
		try {
			backgroundThread.join();
		} catch (InterruptedException e) {
			// Ignore as nothing to be done.
			Thread.currentThread().interrupt();
		}
	}

	/**
	 * Abstract builder for {@link CalculatorServer} with sensible default values.
	 *
	 * To choose concrete {@link TServer} to be used, choose the matching
	 * implementation (e.g. {@link TSimpleServerBuilder}).
	 */
	public static abstract class Builder<T extends Builder<T>> {
		/**
		 * {@link TServerTransport} to be used by {@link CalculatorServer}.
		 */
		private @Nullable TServerTransport transport;

		/**
		 * {@link CalculatorService.Iface} implementation to be used by
		 * {@link CalculatorServer}.
		 */
		private CalculatorService.@NonNull Iface handler = new CalculatorHandler();

		/**
		 * Sets {@link TServerTransport} to be used by {@link CalculatorServer}.
		 *
		 * @param transport Thrift transport to be used by server.
		 * @return {@code this} object.
		 */
		public @NonNull T withTransport(@NonNull TServerTransport transport) {
			this.transport = transport;
			return thisInstance();
		}

		/**
		 * Sets {@link CalculatorService.Iface} implementation to be used by
		 * {@link CalculatorServer}.
		 *
		 * @param handler Interface implementation to be used by server.
		 * @return {@code this} object.
		 */
		public @NonNull T withHandler(CalculatorService.@NonNull Iface handler) {
			this.handler = handler;
			return thisInstance();
		}

		/**
		 * Actually builds {@link CalculatorServer} object.
		 *
		 * @return Server object based on previously set values.
		 * @throws TTransportException if server could not be created.
		 * @see CalculatorServer#CalculatorServer(TServer, TServerTransport)
		 */
		public @NonNull CalculatorServer build() throws TTransportException {
			if (transport == null) {
				transport = defaultTransport();
			}
			CalculatorService.Processor<CalculatorService.Iface> processor = new CalculatorService.Processor<>(handler);
			TServer server = buildServer(transport, processor);
			return new CalculatorServer(server, transport);
		}

		/**
		 * Creates default {@link TServerTransport} to be used by
		 * {@link CalculatorServer} if no other value set.
		 *
		 * @return Default server transport.
		 * @throws TTransportException If server transport could not be opened.
		 */
		protected @NonNull TServerTransport defaultTransport() throws TTransportException {
			return new TServerSocket(9876);
		}

		/**
		 * Utility to avoid class cast warnings when return this instance.
		 *
		 * @return {@code this}.
		 */
		protected abstract @NonNull T thisInstance();

		/**
		 * Actually builds {@link TServer} to be used by {@link CalculatorServer}.
		 *
		 * Parses previously set parameters and returns concrete implementation.
		 *
		 * @param transport {@link TServerTransport} to be used by {@link TServer}.
		 * @param processor {@link CalculatorService.Processor} to be used by
		 *                  {@link TServer}.
		 * @return {@link TServer} to be used by {@link CalculatorServer}.
		 * @throws TTransportException If server could not be set up.
		 */
		protected abstract @NonNull TServer buildServer(@NonNull TServerTransport transport,
				CalculatorService.@NonNull Processor<CalculatorService.Iface> processor) throws TTransportException;
	}

	/**
	 * Extension of {@link Builder} creating a server internally using
	 * {@link TSimpleServer}.
	 */
	public static class TSimpleServerBuilder extends Builder<TSimpleServerBuilder> {
		@Override
		protected @NonNull TSimpleServerBuilder thisInstance() {
			return this;
		}

		@Override
		protected @NonNull TSimpleServer buildServer(@NonNull TServerTransport transport,
				@NonNull Processor<Iface> processor) throws TTransportException {
			return new TSimpleServer(new Args(transport).processor(processor));
		}
	}

	/**
	 * Example showing how to use {@link CalculatorServer}.
	 *
	 * @param args Ignored.
	 * @throws TException If communication error with thrift service occurred.
	 */
	public static void main(String[] args) throws TException {
		// Use builder class to instantiate server
		CalculatorServer server = new TSimpleServerBuilder().build();

		// Run server in background
		try {
			System.out.println("Running the CalculatorService (Press CTRL-C to stop)...");
			server.start();
			server.join();
		} catch (InterruptedException e) {
			// Clear exception
			Thread.currentThread().interrupt();
		} finally {
			server.stop();
		}
	}
}
