package com.philemonworks.flex.net
{
	import mx.utils.ObjectProxy;
	
	public class RestFault
	{
		public var request:String;
		public var method:String;
		public var controller:String;
		public var stack:String;
		public var message:String;
		public var code:String;
		
		public function RestFault(input:Object) {
			super()
			if (input is ObjectProxy) {
				var proxy:ObjectProxy = ObjectProxy(input)
				this.code = proxy.code
				this.request = proxy.request
				this.method = proxy.method
				this.controller = proxy.controller
				this.stack = proxy.stack
				this.message = proxy.message				
			} else if (input is XML) {
				var xml:XML = XML(input)
				this.code = xml.@code
				this.request = xml.request
				this.method = xml.method
				this.controller = xml.controller
				this.stack = xml.stack
				this.message = xml.message
			}
		}
		public function toString():String {
			return "RestFault[code="+this.code+",message="+this.message+"]"
		}
	}
}