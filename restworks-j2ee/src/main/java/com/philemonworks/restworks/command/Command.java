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
package com.philemonworks.restworks.command;

import java.io.StringWriter;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import com.philemonworks.writer.XMLWriter;

public class Command {
	public String name;
	public Map parameters = new LinkedHashMap();
	public Command() {
	};
	public Command(String name) {
		super();
		this.name = name;
	}
	public Command(String name, String parameterName, String argumentValue) {
		super();
		this.name = name;
		this.putParameter(parameterName,argumentValue);
	}
	public void putParameter(String name, String value) {
		parameters.put(name,value);
	}
	public String getParameter(String name){
		return this.getParameter(name,null);
	}
	public int getIntParameter(String name){
		return Integer.parseInt(this.getParameter(name,"0"));
	}
	public boolean getBooleanParameter(String name){
		return "true".equals(this.getParameter(name,"false"));
	}	
	public String getParameter(String parameterName, String absentValue){
		if (parameters.containsKey(name))
			return absentValue;
		return (String)parameters.get(parameterName);
	}
	public String[] getParameterValueArray(){
		String[] params = new String[parameters.size()];
		int index = 0;
		for (Iterator iter = parameters.values().iterator(); iter.hasNext();) {
			params[index++]=(String) iter.next();
		}
		return params;
	}
	public void write(XMLWriter xml) {
		new CommandXmlIO().write(this, xml);
	}
	public String toString(){
		StringWriter sw = new StringWriter();
		sw.write("Command[");
		if(name == null) sw.write("null"); else sw.write(name);
		sw.write("(");
		for (Iterator iter = parameters.keySet().iterator(); iter.hasNext();) {
			String key = (String) iter.next();
			sw.write(key);
			sw.write("=");
			sw.write((String)(parameters.get(key)));
			if (iter.hasNext()) sw.write(",");
		}
		sw.write(")]");
		return sw.toString();
	}
}
