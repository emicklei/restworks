package com.philemonworks.flex.nls
{
	import mx.formatters.DateFormatter;
	import mx.formatters.CurrencyFormatter;
	/**
	 * NLS is a class that encapsulates internationalized values
	 * Based on the language set (nl|us), a lookup of values is done
	 * NLS provides convenience methods to access text (with defaults),dates,money,phone formatter values
	 * 
	 * @author ernest.micklei@philemonworks.com, 2007
	 */ 
	public class NLS
	{
	   public static const NLS_KEY_DATE:String = "nls-format-date"	   
	   private static var nlsProvider:NLSProvider;
	   
		/**
		 * Gets a string from the ResourceBundle for the current language.
		 * Return the absentValue if the key was missing. This exception is traced.
		 */
		public static function text(key:String,absentValue:String = 'NLS-MISSING-KEY'):String {
			if (nlsProvider == null) {
				trace("NLS: no provider")
				return absentValue
			}
			return nlsProvider.getString(key,absentValue)
		}
		/**
		 * Gets a formatted date using the ResourceBundle for the current language.
		 */		
		public static function date(someDay:Date):String {
			return getDateFormatter().format(someDay);
		}
		/**
		 * Gets a formatted monetary amount using the ResourceBundle for the current language.
		 */		
		public static function money(amount:Number):String {
			return getCurrencyFormatter().format(amount)
		}
		//----------------
		// Formatters
		//----------------
		/**
		  <mx:DateFormatter
		    formatString="Y|M|D|A|E|H|J|K|L|N|S"
		   /> 
   		*/ 	
		public static function getDateFormatter():DateFormatter {
		    var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = text(NLS_KEY_DATE,"YY-DD-MM");
			return formatter;			
		}
		/**
		  <mx:CurrencyFormatter
		    alignSymbol="left|right" 
		    currencySymbol="$"
		    decimalSeparatorFrom="."
		    decimalSeparatorTo="."
		    precision="-1"
		    rounding="none|up|down|nearest"
		    thousandsSeparatorFrom=","
		    thousandsSeparatorTo=","
		    useNegativeSign="true|false"
		    useThousandsSeparator="true|false"
			 />
	 	**/
		public static function getCurrencyFormatter():CurrencyFormatter {
			return new CurrencyFormatter();			
		}
		// Setup
		public static function setProvider(otherProvider:NLSProvider):void {
			nlsProvider = otherProvider
		}
	   	public static function getProvider():NLSProvider {
	   		return nlsProvider
	   	}		
	}
}