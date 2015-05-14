package tests
{
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	import flash.utils.describeType;
	import mx.formatters.DateFormatter;
	import com.adobe.utils.DateUtil;
	import mx.controls.Alert;
	import com.philemonworks.flex.util.XMLHelper;
	
	public class XMLHelperTest extends TestCase 
	{	
		// 
		private var typedvalues:XML = <types>
			<boolean-true>true</boolean-true>
			<boolean-false>false</boolean-false>
			<integer>-42</integer>
			<datetime-gmt>2007-06-21T15:06:00+02:00</datetime-gmt>
			<datetime-zulu>2007-06-06T10:59:20Z</datetime-zulu>
			<float>3.14159</float>
			</types>
		
  		public function testStringToNumber():void {
  			var i:Number = XMLHelper.stringToNumber(typedvalues["integer"])  		
  			assertTrue(i==-42)
  		}
  		public function testNumberToString():void {
  			var s:String = XMLHelper.numberToString(42)
  			assertEquals("42",s)
  		}
  		public function testStringToBoolean():void {
  			assertTrue(XMLHelper.stringToBoolean(typedvalues["boolean-true"]))
  			assertFalse(XMLHelper.stringToBoolean(typedvalues["boolean-false"]))
  		}  
  		public function testNullToBoolean():void {
  			assertFalse(XMLHelper.stringToBoolean(null))
  		}  				
  		public function testStringToDate():void {  			
  			assertTrue(XMLHelper.stringToDate(typedvalues["datetime-gmt"]).date == 21)
  		}
  		public function testStringToDateZulu():void {  			
  			assertTrue(XMLHelper.stringToDate(typedvalues["datetime-zulu"]).date == 6)
  		}  		
  		public function testIntegerToString():void {  			
  			assertTrue(XMLHelper.intToString(42) == "42")
  		}  	
  		public function testStringToInteger():void {  			
  			assertTrue(XMLHelper.stringToint("42") == 42)
  		}   			
  		public function testDateToString():void {  			
  			var d:Date = XMLHelper.stringToDate(typedvalues["datetime-zulu"])
  			var s:String = XMLHelper.dateToString(d)
  			assertTrue(typedvalues["datetime-zulu"], s)
  		}  
	}
}