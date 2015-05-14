package tests
{
	import flexunit.framework.TestCase;
	import com.philemonworks.flex.util.Day;

	public class DayTest extends TestCase
	{

		public function testDayFromString():void {
			var day:Day = new Day("2007-06-20")
			assertEquals(2007, day.asDate().fullYear)
		}
		
		public function testAsDate():void {
			var day:Day = new Day("2008-02-04")
			var date:Date = day.asDate()			
			assertEquals(2008, date.fullYear)
			// The month (0 for January, 1 for February, and so on)
			assertEquals(1, date.month)
			// The day of the month (an integer from 1 to 31)
			assertEquals(4, date.date)
		}		
	}
}