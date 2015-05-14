package com.philemonworks.flex.navigation
{
	import mx.rpc.events.ResultEvent;
	import flash.events.Event;
	import com.philemonworks.flex.net.RestClient;
	
	public class PageNavigator
	{
		private var client:RestClient = new RestClient("e4x");
		
		public var resultFunction:Function;
		public var _bar:PageNavigationBar;
	
		public var firstRowOnPage:Number = 0;
		public var lastRowOnPage:Number = 0;
		public var totalRows:Number = 0;
		public var rowsPerPage:Number = 0;
		public var windowlessUrl:String = null;
		public var sortmethod:String = "descending";
		public var sortkey:String = null;
		
		public function get bar():PageNavigationBar { return _bar; }
		public function set bar(newBar:PageNavigationBar):void{
			_bar = newBar;
			_bar.addEventListener("click" , pageRequested);
		}
		
		// the user has requested to view a page (could be refresh of the current)
		public function pageRequested(event:Event):void {
			trace("PageNavigator>>user requested page")
			firstRowOnPage = (_bar.requestedPage - 1 ) * rowsPerPage
			this.fetchPage()
		}
		
		public function pageRequestURL():String {
			var request:String = windowlessUrl;
			if (request.indexOf("?") == -1)
				request += "?";
			else
				request += "&";
			request = request + "from=" + this.firstRowOnPage + "&to=" + (firstRowOnPage+rowsPerPage-1);
			if (sortkey != null) {
				request = request + "&sortkey=" + sortkey + "&sortmethod=" + sortmethod;
			}
			return request;
		}
		
		public function reset():void {
			trace(this+">reset");
			firstRowOnPage = 0;
			lastRowOnPage = 0;
			rowsPerPage = 10;
			totalRows = 0;
		}	

		public function fetchPage():void {
			if (windowlessUrl == null){
				trace("PageNavigator has no base url");
				return;
			}
			if (_bar == null){
				trace("PageNavigator has no navigationbar");
				return;
			}
			client.send_get(this.pageRequestURL(), dataReceived);
		}

		public function dataReceived(data:XML):void {			
			resultFunction.call(this,data,this);
			// update pages on the navigation bar
			_bar.updatePageControlsByRows(firstRowOnPage,rowsPerPage,totalRows);
		}
		
		public function toString():String {
			return "PageNavigator>>firstRowOnPage,rowsPerPage,totalRows:" + firstRowOnPage + "," + rowsPerPage + "," + totalRows;
		}		
	}
}