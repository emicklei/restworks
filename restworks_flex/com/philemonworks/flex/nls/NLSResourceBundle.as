package com.philemonworks.flex.nls
{
	import mx.resources.ResourceBundle;
	
	public class NLSResourceBundle implements NLSProvider
	{
		[ResourceBundle("nls_locale_us")]  // requires nls.locale_us.properties files containing key=value lines
		private static var bundle_us:ResourceBundle;
		[ResourceBundle("nls_locale_nl")]  // requires nls.locale_nl.properties files containing key=value lines
		private static var bundle_nl:ResourceBundle;
		public static const LOCALE_US:String = "us"
		public static const LOCALE_NL:String = "nl"
				
		public var _language:String = "us";
		
		// Constructor
		public function NLSResourceBundle(language:String) {
			super()
			this._language = language
		}
		
		// NLSProvider API
		public function language():String { return _language }

		// NLSProvider API		
		public function getString(key:String,absentValue:String):String {
			try {
				if (LOCALE_US == _language) return bundle_us.getString(key)
				if (LOCALE_NL == _language) return bundle_nl.getString(key)
			} catch (e:Error) {
				// Probably key absent
				trace("NLS warning: unable to get string because: " + e.message);
			}
			return absentValue			
		}
	}
}