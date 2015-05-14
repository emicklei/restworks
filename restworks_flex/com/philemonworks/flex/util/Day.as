package com.philemonworks.flex.util
{
	import mx.formatters.DateFormatter;
	
	/**
	 * 1967-11-20
	 */
	public class Day
	{
		private var formattedDay:String
		
		public function Day(dayString:String = "") {
			super()			
			if (dayString.length != 0) {
				formattedDay = dayString
			} else {
				this.setDate(new Date())
			}
		}
		public function toString():String {
			return formattedDay 
		}
		public function asDate():Date {
			var parts:Array = formattedDay.split('-')
			// The month (0 for January, 1 for February, and so on)
			// The day of the month (an integer from 1 to 31)
			return new Date(int(parts[0]),int(parts[1])-1,int(parts[2]))
		}
		public function setDate(dateTime:Date):void {
			var formatter:DateFormatter = new DateFormatter()
			formatter.formatString = "YYYY-MM-DD"
			formattedDay = formatter.format(dateTime)						
		}
	}	
}