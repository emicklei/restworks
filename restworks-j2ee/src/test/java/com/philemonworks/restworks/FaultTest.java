package com.philemonworks.restworks;

import com.philemonworks.writer.XMLWriter;
import com.philemonworks.writer.XSDWriter;
import junit.framework.TestCase;

public class FaultTest extends TestCase {
	
	public void testFaultSchema(){
		XSDWriter xsd = new XSDWriter(System.out);
		xsd.openSchema2001();
		RestFault.write(xsd);
		xsd.closeSchema();
	}
	
	public void testFault(){
		RestFault fault = new RestFault();
		fault.request = "/here";
		fault.method = "PUT";
		fault.code = "987";
		fault.message = "<testmessage>";
		fault.stackTrace = "?";
		fault.write(new XMLWriter(System.out));
	}
}
