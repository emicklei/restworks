package tests
{
	import com.philemonworks.flex.util.Randomizer;
	import flexunit.framework.TestCase;
	import mx.controls.Alert;
	import com.philemonworks.flex.util.XMLHelper;
	
	public class RandomizerTest extends TestCase 
	{
		public var rnd:Randomizer = new Randomizer();
		
		public function testInt():void {
  			assertTrue(rnd.nextInt(0,10) < 11)
  		}
  		public function testAll():void {
  			var person:XML = <person>
  					<name>{rnd.nextForename()}</name>
  					<lastname>{rnd.nextLastname()}</lastname>
  					<age>{rnd.nextInt(1,99)}</age>
  					<married>{rnd.nextBoolean()}</married>
  					<graduated>{XMLHelper.dateToString(rnd.nextDate())}</graduated>
  				</person>
  			trace(person.toXMLString())
  		}
	}
}