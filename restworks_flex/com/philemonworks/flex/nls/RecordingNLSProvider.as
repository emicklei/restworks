package com.philemonworks.flex.nls
{
	import com.philemonworks.flex.nls.NLSProvider;

	public class RecordingNLSProvider implements NLSProvider
	{
		private var entries:XML;
		private var fallback:NLSProvider;
		[Bindable]
		public var recordNewOnly:Boolean = false;
		
		public function RecordingNLSProvider(hitmissProvider:NLSProvider = null) {
			super()
			this.fallback = hitmissProvider
			this.entries = <locale language={fallback == null ? 'us' : fallback.language} />
		}
		
		public function getString(key:String, absentValue:String):String
		{
			var value:String = entries[key]
			if (value.length == 0) {
				if (fallback != null) {
					value = fallback.getString(key,null)
					if (value != null) {
						if (!recordNewOnly) entries[key]=value
						return value
					}
				}
				trace("[nls recorder] hit miss, recording default value for:" + key)
				entries[key] = absentValue
				value = absentValue
			}
			return value				
		}
		
		public function language():String
		{
			return entries.@language;
		}
		
		public function getPropertiesContents():String {
			var buffer:String = ''
			var keys:Array = []
			for each (var entry:XML in entries.children()) {
				keys.push(entry.name())
			}
			keys.sort()
			for each (var key:String in keys) {	
				 buffer += key + "=" + entries[key] + "\n"
			}
			return buffer
		}		
	}
}