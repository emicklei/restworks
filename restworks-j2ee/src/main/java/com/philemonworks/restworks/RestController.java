/*
 Copyright 2007 Ernest Micklei @ PhilemonWorks.com

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */
package com.philemonworks.restworks;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import org.apache.log4j.Logger;
import com.philemonworks.restworks.command.Command;
import com.philemonworks.restworks.command.CommandXmlIO;
import com.philemonworks.restworks.command.Reply;

public abstract class RestController {
	final Logger LOG = Logger.getLogger(this.getClass());

	public void service(RestInvocation invocation) {
		String method = invocation.getHttpRequest().getMethod();
		// detect method and dispatch accordingly
		if ("GET".equals(method))
			this.doGet(invocation);
		else if ("PUT".equals(method))
			this.doPut(invocation);
		else if ("POST".equals(method))
			this.doPost(invocation);
		else if ("DELETE".equals(method))
			this.doDelete(invocation);
		else LOG.debug("did not handle: " + method);
	}

	public void doGet(RestInvocation invocation) {
		if (!invocation.tokenAvailable()) {
			this.doGetAll(invocation);
			return;
		}
		// assume the next token is an identifier (if not then you should redefine the method doGet)
		this.doGetByID(invocation.nextToken(), invocation);
	}

	public void doGetByID(String id, RestInvocation invocation) {
		String warning = "did not handle: doGetByID(" + id + "," + invocation + ")";
		LOG.warn(warning);
		throw new RuntimeException(warning);
	}

	public void doGetAll(RestInvocation invocation) {
		String warning = "did not handle: doGetAll(" + invocation + ")";
		LOG.warn(warning);
		throw new RuntimeException(warning);
	}

	public void doPost(final RestInvocation invocation) {
		if (invocation.peekFor(this.commandToken())) {
			this.doCommand(invocation);
		} else {
			String warning = "did not handle: doPost(" + invocation + ")";
			LOG.warn(warning);
			throw new RuntimeException(warning);
		}
	}
	/**
	 * This token is used to detect whether the controller is receiving a Command.
	 * So if the controller is configured to get invocations from /products
	 * then POST requests to /products/command will be dispatched as a Command
	 * @return
	 */
	public String commandToken(){
		return "command";
	}
	
	protected void doCommand(final RestInvocation invocation) {
		final CommandXmlIO cmdIO = new CommandXmlIO();
		invocation.parseInput(cmdIO);
		if (cmdIO.command == null) {
			throw new RuntimeException("Command as XML expected");
		}
		if (LOG.isDebugEnabled()) {
			LOG.debug(cmdIO.command);
		}
		invocation.respondWith(this.execute(cmdIO.command));
	}
	
	protected Reply execute(final Command command) {
		Reply reply;
		try {
			// TODO: currently only String arguments are supported
			final Class[] argumentTypes = new Class[command.parameters.size()];
			for (int i = 0; i < argumentTypes.length; i++) { argumentTypes[i] = String.class; }
			final Method call = this.getClass().getMethod(command.name, argumentTypes);
			reply = (Reply) (call.invoke(this, command.getParameterValueArray() ));
		} catch (SecurityException e) {
			LOG.error("failed to execute ["+command.name+"]",e);
			throw new RuntimeException("Failed to execute command named \""+command.name+"\"",e);
		} catch (NoSuchMethodException e) {
			LOG.error("failed to execute ["+command.name+"]",e);
			throw new RuntimeException("Failed to execute command named \""+command.name+"\"",e);
		} catch (IllegalArgumentException e) {
			LOG.error("failed to execute ["+command.name+"]",e);
			throw new RuntimeException("Failed to execute command named \""+command.name+"\"",e);
		} catch (IllegalAccessException e) {
			LOG.error("failed to execute ["+command.name+"]",e);
			throw new RuntimeException("Failed to execute command named \""+command.name+"\"",e);
		} catch (InvocationTargetException e) {
			LOG.error("failed to execute ["+command.name+"]",e);
			throw new RuntimeException("Failed to execute command named \""+command.name+"\"",e);
		}
		return reply;
	}

	public void doPut(RestInvocation invocation) {
		String warning = "did not handle: doPut(" + invocation + ")";
		LOG.warn(warning);
		throw new RuntimeException(warning);
	}

	public void doDelete(RestInvocation invocation) {
		String warning = "did not handle: doDelete(" + invocation + ")";
		LOG.warn(warning);
		throw new RuntimeException(warning);
	}
	/**
	 * I am about to be destroyed by my containing servlet. Do something if needed.
	 */
	public void destroy(){
		LOG.debug("destroy");
	}
}
