package com.philemonworks.flex.navigation
{
	import com.philemonworks.flex.navigation.PageNavigationBar;
	
	import mx.controls.DataGrid;
	import mx.core.UIComponent;
	import mx.containers.HBox;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.IFactory;
	import mx.controls.Alert;
	import mx.events.DataGridEvent;
	import mx.core.ClassFactory;
	import com.philemonworks.flex.navigation.PageNavigator;
	import flash.events.Event;
	
	public class PageNavigationManager
	{		
		private var _dataGrid:DataGrid;
		private var _navigator:PageNavigator = new PageNavigator()
		
		public function PageNavigationManager(){
			super()
		}
		
		public function set pageLoaded(callback:Function):void {
			_navigator.resultFunction = callback
		}
		
		public function set url(baseUrl:String):void {
			_navigator.windowlessUrl = baseUrl
		}
		
		public function set navigationBar(bar:PageNavigationBar):void {
			_navigator.bar = bar
		}
		
		public function set dataGrid(newDataGrid:DataGrid):void {
			_dataGrid = newDataGrid
/* 			for each (var c:DataGridColumn in _dataGrid.columns) {
				c.headerRenderer = new ClassFactory(PageNavigationHeaderRenderer)
				c.addEventListener("globalSortChanged", headerClicked)
			}	 */		
		}		
		
/* 		public function headerClicked(event:DataGridEvent):void {
			event.preventDefault()
			var header:PageNavigationHeaderRenderer = event.itemRenderer as PageNavigationHeaderRenderer
			var column:DataGridColumn = event.currentTarget as DataGridColumn
			_navigator.sortkey = column.dataField
			_navigator.sortmethod = header.getSortmethod()
			_navigator.reset() // row info
			this.update()
		} */
		
		public function update():void {
    		trace(this+">>update");
    		_navigator.rowsPerPage = this.computePageSize();
    		_navigator.fetchPage();
    	}
    	
    	public function sortInfo(sortkey:String,sortmethod:String):void {
    		_navigator.sortkey = sortkey
    		_navigator.sortmethod = sortmethod
    	}
    	
    	private function computePageSize():Number {
			return Math.round(_dataGrid.height / Math.max(_dataGrid.rowHeight,24)) - 1 - 1; // header & partly visible bottom row
		}
		
		public function updatePageInfo(from:Number,to:Number,total:Number):void {
			_navigator.firstRowOnPage = from
			_navigator.lastRowOnPage = to
			_navigator.totalRows = total
		}
	}
}