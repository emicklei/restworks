package com.philemonworks.flex.util
{
	import com.adobe.utils.DateUtil;
	
	/**
	 * XMLHelper is a utility class used to transform XML data into AS types and back
	 * 
	 * Rails db types: integer, float, datetime, date, timestamp, time, text, string, binary and boolean.
	 * Flex     types: int    , Number, Date   , Day*, Date,      Date, string, string, ? , Boolean
	 */
	public class XMLHelper
	{
		
		public static function stringToDay(value:String):Day {
			return new Day(value)
		}
		public static function dayToString(value:Day):String {
			return value.toString()
		}		
		public static function stringToint(value:String):int {
			return int(value)
		}
		public static function intToString(value:int):String {
			return String(value)
		}
		public static function stringToNumber(value:String):Number {
			return Number(value)
		}
		public static function numberToString(value:Number):String {
			return value.toString()
		}	
		public static function stringToBoolean(value:String):Boolean {
			return value != null && value.toLowerCase() == "true"
		}	
		public static function booleanToString(value:Boolean):String {
			return value.toString()
		}				
		public static function stringToDate(value:String):Date {
			if (value.length == 0) return null
			return DateUtil.parseW3CDTF(value)
		}	
		public static function dateToString(value:Date):String {
			if (value == null) return null			
			return DateUtil.toW3CDTF(value,false)
		}	
	}
}