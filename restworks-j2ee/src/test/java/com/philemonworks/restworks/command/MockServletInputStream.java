package com.philemonworks.restworks.command;

import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletInputStream;

public class MockServletInputStream extends ServletInputStream {

	private InputStream bis;
	
	public int read() throws IOException {
		return bis.read();
	}

	public MockServletInputStream(InputStream is){
		super();
		bis = is;
	}
}
