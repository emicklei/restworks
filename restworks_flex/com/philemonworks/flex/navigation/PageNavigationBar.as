package com.philemonworks.flex.navigation
{
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.LinkButton;
	import mx.binding.utils.BindingUtils;
	import flash.text.TextLineMetrics;
	import mx.controls.Text;
	import flash.events.MouseEvent;
	/**
	 * PageNavigationBar is a dynamic control containing LinkButtons for pages from a range.
	 * Depending on the current page and the total number of pages, the bars shows:
	 * <ul>
	 * 	<li>a previous buttons (if valid)</li>
	 *  <li>dots between page 1 and the start of the page window</li>
	 *  <li>linkbuttons for each page of the page window (size=10)</li>
	 *  <li>dots between the last page of the window and the total pages</li>
	 *  <li>a next buttons (if valid)</li>
	 * </ul>
	 * 
	 * @author ernest.micklei@philemonworks.com
	 * @edited 2007-03-29
	 **/
	public class PageNavigationBar extends HBox
	{
		[Bindable]
		public var requestedPage:int = 0; // means no selection
		
		public function updatePageControlsByRows(firstRowOnPage:Number,rowsPerPage:Number,totalRows:Number):void {
			var currentPage:int = firstRowOnPage / rowsPerPage + 1;
			var totalPages:int = Math.ceil(totalRows / Math.max(rowsPerPage,1)); // at least one page
			this.setPageControls(currentPage,totalPages);
		}
			
	    /**
		 * 
		 * @param currentPage
		 * @param totalPages
		 * 
		 */
		public function setPageControls(currentPage:int,totalPages:int):void {			
			this.removeAllChildren();
			// previous
			var prev:Button = new Button();
			prev.width = 18;
			prev.label = "<";
			prev.toolTip = "Goto previous page";
			prev.addEventListener(MouseEvent.CLICK,previousPageButtonClicked);
			this.addChild(prev);
			// gray out if not applicable
			prev.enabled = currentPage > 1;
			// 1		
			this.addLink(1,1==currentPage);
			if (totalPages <= 1) {
				this.addNext(false)
				return
			}
			var left:int = 2;
			var right:int = 0;
			if (currentPage > 6 && totalPages > 10) {
				this.addDots();	
				left = Math.min(currentPage - 4,totalPages-9);										
				right = Math.min(left + 9,totalPages-1);
			} else {
				// without dots one page less
				right = Math.min(left + 8,totalPages-1);	
			}			
			this.addLinks(left,currentPage,right);
			// dots
			if (right < (totalPages-1)) this.addDots();			
			// totalPages	
			this.addLink(totalPages,totalPages==currentPage);
			// next
			this.addNext(currentPage < totalPages)
			
		}
		private function addNext(isEnabled:Boolean):void {
			var next:Button = new Button();
			next.width = 18;
			next.label = ">";
			next.toolTip = "Goto next page";
			next.addEventListener(MouseEvent.CLICK,nextPageButtonClicked);
			this.addChild(next);
			// gray out if not applicable
			next.enabled = isEnabled
		}
		private function addDots():void {
			var dots:Text = new Text();
			dots.text = "...";
			this.addChild(dots);
		}
		private function addLinks(fromPage:int,currentPage:int,toPage:int):void {
			for (var i:int=fromPage; i<=toPage ; i++){
				this.addLink(i,i==currentPage);
			}
		}
		private function addLink(i:int,isCurrent:Boolean):void {
			var link:LinkButton = new LinkButton();	
			
			var label:String = i.toString();
			link.width = 4+(12*label.length);	// TODO dubious width computation	
			link.label = i.toString();
			link.addEventListener(MouseEvent.CLICK,pageButtonClicked);
			if (isCurrent){
				requestedPage = i;
				link.toolTip = "You see page "+i;
				link.setStyle("color","#0080ff");				
			} else {
				link.toolTip = "Goto page "+i;	
			}
			this.addChild(link);
		}		
		private function previousPageButtonClicked(event:MouseEvent):void {
	    	requestedPage--;
	    }
		private function nextPageButtonClicked(event:MouseEvent):void {
	    	requestedPage++;
	    }
	    private function pageButtonClicked(event:MouseEvent):void {
	    	var target:LinkButton = (LinkButton)(event.currentTarget);
	    	requestedPage = Number(target.label);
	    }		
	}
}