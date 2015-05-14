package com.philemonworks.flex.net
{
	//  <reply status="ok">
	//		<result>42</result>
	//		<message>Answer to everything</message>
	//		<message>for everybody</message>	
	//  </reply>
	
	public class Reply
	{
		public var status:String;
		public var result:String;
		public var messages:Array = [];
		
		public function Reply(data:XML = null) {
			super()
			if (data != null) {
				this.status = data.@status
				this.result = data.result
				if (data.message != null) {
					for each(var msg:XML in data..message) {
						this.messages.push(msg.text().toString())
					}
				}
			}
		}
		public function hasMessages():Boolean {
			return messages != null && messages.length > 0
		}
		
		public function toString():String {
			return "Reply[status=" + status + ",result=" + result + ",#messages=" + String(this.messages.length)+"]"
		}
	}
}