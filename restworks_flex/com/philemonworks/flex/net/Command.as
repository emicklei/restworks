package com.philemonworks.flex.net
{
	public class Command
	{
		public var name:String;
		public var parameters:Object = {};
		
		public function Command(newName:String, 
				name0:String = null, value0:String = null, 
				name1:String = null, value1:String = null,
				name2:String = null, value2:String = null){
			super()
			name = newName
			if (name0 != null) this.setParameter(name0,value0)
			if (name1 != null) this.setParameter(name1,value1)
			if (name2 != null) this.setParameter(name2,value2)					
		}
		public function setParameter(key:String,value:String):void {
			this.parameters[key]=value
		}
		public function toXML():XML {
			var xml:XML = <command name={name} />
			for (var key:String in parameters){
				xml.appendChild( <parameter name={key} value={this.parameters[key]} /> )
			}
			return xml
		}
		public function toString():String {
			var line:String = "Command[name=" + name
			for (var key:String in parameters){
				line += "," + key + "=" + this.parameters[key]
			}
			return line += "]"
		}
	}
}