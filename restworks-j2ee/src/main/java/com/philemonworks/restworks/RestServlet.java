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

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import com.philemonworks.writer.XMLWriter;

/**
 * RestServlet is a J2EE Servlet that routes requests to RestControllers passing the request wrapped by a RestInvocation. 
 * 
 * <code><![[CDATA[
 <init-param>
 <param-name>configurator</param-name>
 <param-value>{your com.philemonworks.restworks.IRestServletConfigurator implementor}</param-value>
 </init-param>
 ]>></code>
 * 
 * @author ernest
 */
public class RestServlet extends HttpServlet {
	private static final long serialVersionUID = -6838446677115011845L;
	private final static Logger LOG = Logger.getLogger(RestServlet.class);
	Map controllers = new HashMap();
	protected void service(final HttpServletRequest httpReq, final HttpServletResponse httpResp) throws ServletException, IOException {
		final RestInvocation invocation = new RestInvocation(httpReq, httpResp);
		if (LOG.isDebugEnabled())
			LOG.debug(httpReq.getMethod()+" - service:"+ invocation);
		if (invocation.tokenAvailable()) {			
			RestController rc = this.controllerConfiguredFor(invocation);
			if (rc != null) {
				try {
					rc.service(invocation);
				} catch (Exception ex) {										
					this.handleInvocationException(ex, invocation, rc);
				}
			} else {
				if (LOG.isDebugEnabled()) {
					this.handleUnkownPath(invocation);
				} else {
					super.service(httpReq, httpResp);
				}
			}
			// copy the invocation buffer output to the response output
			// unless content was already written directly
			if (!httpResp.isCommitted()) {
				httpResp.getOutputStream().write(invocation.getOutputBytes());
				httpResp.getOutputStream().flush();
				httpResp.getOutputStream().close();
			}
		} else {
			httpResp.sendError(404);
		}
	}
	private RestController controllerConfiguredFor(RestInvocation invocation){
		String next = invocation.nextToken();
		return (RestController) controllers.get(next);
	}
	private void handleUnkownPath(RestInvocation invocation){
		LOG.warn("Unknown path:" + invocation);
		invocation.flushBuffer();
		RestFault fault = this.createFault(invocation);
		StringWriter sw = new StringWriter();
		sw.write("[debug] Unable to route the request to a controller. Check your RestServlet configuration. \n" );
		List keys = new ArrayList(controllers.keySet());
		Collections.sort(keys);
		for (Iterator iter = keys.iterator(); iter.hasNext();) {
			String path = (String) iter.next();
			sw.write("[");
			sw.write(path);
			sw.write("=>");
			sw.write(controllers.get(path).getClass().getName());
			sw.write("] ");			
		}
		fault.message = sw.toString();
		fault.write(invocation.getPreparedXMLWriter());
	}
	private RestFault createFault(RestInvocation invocation) {
		RestFault fault = new RestFault();
		fault.request = invocation.getHttpRequest().getRequestURI();
		fault.method = invocation.getHttpRequest().getMethod();
		return fault;
	}
	protected void handleInvocationException(Exception ex, RestInvocation invocation, RestController rc) {
		LOG.error("controller ["+rc+"] failed to service ["+invocation+"]",ex);
		invocation.flushBuffer();
		XMLWriter xml = invocation.getPreparedXMLWriter();
		RestFault fault = this.createFault(invocation);
		fault.message = ex.getLocalizedMessage();
		// stack only available in DEBUG mode
		if (LOG.isDebugEnabled()) {
			StringWriter sw = new StringWriter();
			ex.printStackTrace(new PrintWriter(sw));
			fault.stackTrace = sw.toString();
			fault.controller = rc.toString();
		}
		fault.write(xml);
	}
	public void init(ServletConfig config) throws ServletException {
		IRestServletConfigurator configurator;
		String configClassName = config.getInitParameter("configurator");
		if (configClassName == null)
			throw new RuntimeException(
					"Missing servlet parameter value for [configurator]. This must be and implementor of the IRestServletConfigurator interface");
		else
			try {
				configurator = (IRestServletConfigurator) RestUtils.safeInstanceFromClassName(configClassName);
			} catch (ClassNotFoundException cnfe) {
				throw new RuntimeException("Invalid class name for the [configurator] parameter of the RestServlet. Check your web.xml" , cnfe);
			}
		LOG.debug("Configuring using [" + configurator + "]");
		try {
			configurator.configure(this, config);
		} catch (Exception ex) {
			LOG.error("Failed to configure RestServlet:" + ex.getLocalizedMessage());
			throw new ServletException("RestServlet configuration failed", ex);
		}
		super.init(config);
	}
	public void configure(String path, RestController rc) {
		if (controllers.containsKey(path)) {
			LOG.warn("Overriding controller for request token [" + path + "]");
		}
		LOG.debug("Requests starting at ["+path+"] are dispatched to controller [" + rc + "]");
		controllers.put(path, rc);
	}
	/**
	 * I am about to be destroyed. Notify all controllers so they can release any resources claimed.
	 */
	public void destroy(){
		for (Iterator iter = controllers.values().iterator(); iter.hasNext();) {
			RestController each = (RestController) iter.next();
			each.destroy();
		}
	}
	Map getControllers(){
		return controllers;
	}
}
