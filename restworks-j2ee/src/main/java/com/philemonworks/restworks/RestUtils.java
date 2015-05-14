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

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.apache.log4j.Logger;
import org.xml.sax.helpers.DefaultHandler;

public class RestUtils {

	public static Object safeInstanceFromClassName(String qualifiedName) throws ClassNotFoundException{
		try {
			Class cls = Thread.currentThread().getContextClassLoader().loadClass(qualifiedName);
			return cls.newInstance();
		} catch (ClassNotFoundException cfne) {
			Logger.getLogger(RestUtils.class).error("safeInstanceFromClassName:"+qualifiedName,cfne);
			// let caller do proper exception handling
			throw cfne;
		} catch (Exception e) {
			Logger.getLogger(RestUtils.class).error("safeInstanceFromClassName:"+qualifiedName,e);
			throw new RuntimeException("safeInstanceFromClassName:"+qualifiedName,e);
		}
	}

	public static List asList(Object theone) {
		ArrayList single = new ArrayList(1);
		single.add(theone);
		return single;
	}
	public static String appendQueryPair(String uri, String key, String value){
		String path = uri;
		if (uri.indexOf('?') != -1) path += '&'; else path += '?';
		try {
			path += key + "=" + URLEncoder.encode(value, "utf-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("query parameter value encoding failed",e);
		}
		return path;
	}
	public static String withoutSuffix(String input, String suffix){
		if (!input.endsWith(suffix)) return input;
		return input.substring(0,input.lastIndexOf(suffix));
	}
	/**
	 * Process the data available on the input stream using a SAX Handler implementor
	 * @param reader DefaultHandler
	 * @param inputStream InputStream
	 */
	public static void parseInputStream (DefaultHandler reader, InputStream inputStream){
		try {
			SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
			parser.parse(inputStream, reader);
		} catch (Exception e) {
			throw new RuntimeException("Failed to parse input",e);
		}	
	}
	/**
	 * Use the reader (a SAX Handler) to parse the input xml.
	 * @param reader DefaultHandler
	 * @param xmlString String
	 */
	public static void parseInput(DefaultHandler reader, String xmlString){
		RestUtils.parseInputStream(reader, new ByteArrayInputStream(xmlString.getBytes()));
	}
}
