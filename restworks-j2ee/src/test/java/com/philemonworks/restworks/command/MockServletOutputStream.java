package com.philemonworks.restworks.command;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.servlet.ServletOutputStream;

public class MockServletOutputStream extends ServletOutputStream {

	private ByteArrayOutputStream bos;

	public void write(int b) throws IOException {
		bos.write(b);
	}

	public MockServletOutputStream(ByteArrayOutputStream bossie){
		super();
		bos = bossie;
	}
	
}
