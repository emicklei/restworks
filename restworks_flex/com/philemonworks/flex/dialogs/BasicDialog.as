package com.philemonworks.flex.dialogs
{
	import mx.containers.TitleWindow;
	import mx.managers.PopUpManager;
	import mx.core.IFlexDisplayObject;
	import flash.events.Event;
	
	public class BasicDialog extends TitleWindow
	{
		public var center:Boolean = true;
		protected var accepted:Boolean = false;
		protected var okCallback:Function;
				
		protected function doOk():void {
			accepted = true
			this.closeThis()
		}
		
		// this is called when the window is closed
		protected function closeFromPopup(event:Event):void {
			this.closeThis();
		}		
		// this is called directly from the buttons or indirectly from the window
		protected function closeThis():void {
			PopUpManager.removePopUp(IFlexDisplayObject(this));
			// this causes the function to be executed on the object that "popupped" the login
			if (this.validateOk()) okCallback.call(this,this);
		}				
		public function show(okHandler:Function = null):void {
			okCallback = okHandler
			if (center) PopUpManager.centerPopUp(this);								
			this.addEventListener("close", this.closeFromPopup);
		}
		// Subclasses may redefine this to do extra checks.
		// Do not forget to call super.validateOk()
		protected function validateOk():Boolean {
			return okCallback != null && accepted
		}		
	}
}