package com.philemonworks.restworks.command;

import java.io.ByteArrayInputStream;
import junit.framework.TestCase;
import org.apache.log4j.BasicConfigurator;
import com.philemonworks.restworks.RestInvocation;

public class CommandControllerTest extends TestCase {

	public void setUp(){ BasicConfigurator.configure(); }
	
	public void testExample(){
		ExampleController ec = new ExampleController();
		MockHttpRequest request = new MockHttpRequest();
		request.setInputStream(new ByteArrayInputStream("<command name='example' />".getBytes()));
		RestInvocation invocation = new RestInvocation(request,new MockHttpResponse());
		invocation.tokens = new String[]{"command"};
		ec.doPost(invocation);
	}
	public void testExampleUnknown(){
		ExampleController ec = new ExampleController();
		MockHttpRequest request = new MockHttpRequest();
		request.setInputStream(new ByteArrayInputStream("<command name='unkown' />".getBytes()));
		RestInvocation invocation = new RestInvocation(request,new MockHttpResponse());
		invocation.tokens = new String[]{"command"};
		try {
			ec.doPost(invocation);			
			fail("should have catched");
		} catch (RuntimeException re) {
			
		}
	}
}
