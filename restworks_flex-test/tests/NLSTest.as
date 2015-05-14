package tests
{
	import flexunit.framework.TestCase;
	import com.philemonworks.flex.nls.NLS;
	import com.philemonworks.flex.nls.NLSResourceBundle;

	public class NLSTest extends TestCase
	{
		override public function setUp():void {
			NLS.setProvider(new NLSResourceBundle("us"))
		}
		
		public function testGetText():void {
			assertEquals(NLS.text('test'),'TestMe')
			NLS.setProvider(new NLSResourceBundle("nl"))
			assertEquals(NLS.text('test'),'TestMij')
		}
		public function testGetTextDefault():void {
			assertEquals(NLS.text('missing','DEFAULT'),'DEFAULT')
		}		
		public function testGetDate():void {
			assertNotNull(NLS.date(new Date()))
		}
		public function testGetMoney():void {
			assertNotNull(NLS.money(123.45))
		}
	}
}