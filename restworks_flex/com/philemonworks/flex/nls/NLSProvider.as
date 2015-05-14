package com.philemonworks.flex.nls
{
	public interface NLSProvider
	{
		function language():String;
		function getString(key:String,absentValue:String):String;
	}
}