package com.philemonworks.flex.net
{
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;
	import mx.utils.ObjectProxy;
	import flash.display.Sprite;
	import mx.core.Application;
	import mx.rpc.AsyncToken;
	
	/**
	 * RestClient is a small wrapper for the standard HTTPService
	 * that handles both ResultEvents and FaultEvents when sending a GET or POST request.
	 * 
	 * ResultEvents are processed to call the function with a Reply or XML object
	 * FaultEvents are processed by opening a FaultWindow reporting the problem
	 * 
	 * @author ernest.micklei@philemonworks.com, 2007
	 */
	public class RestClient
	{
		private var http:HTTPService = new HTTPService()
		private var currentCallback:Function
		public var resultFormat:String = "object"; // default for HttpService			
    	/**
		 *  Constructor with other result format.
		 */
	    public function RestClient(otherResultFormat:String = "object") {
			super();
			this.init();
			resultFormat = otherResultFormat
	    }	    
			
		private function init():void {			
			http.useProxy = false
			http.requestTimeout = 10 // seconds before give up
			http.addEventListener("result", handleResultReceived)
			http.addEventListener("fault", handleFaultReceived)
		}
		
		public function send_post(data:XML,url:String,callback:Function):void {
			trace("\t[restclient] POST:\n"+data+"\nto:" + url);
			this.http.resultFormat = resultFormat;
			this.currentCallback = callback;
			this.http.url = url;
			this.http.contentType = "application/xml"
			this.http.method = "POST"
			this.http.send(data);			
		}
				
		public function send_get(url:String,callback:Function):void {
			if (this.currentCallback != null) {
				Alert.show("can not reuse RestClient instance");
				return;
			}
			this.http.resultFormat = resultFormat;			
			this.currentCallback = callback;
			this.http.url = url;
			this.http.method = "GET"
			var token:AsyncToken = this.http.send();	
			trace("\t[restclient] GET:" + url);			
		}
		
		private function handleResultReceived(event:ResultEvent):void {						
			if (event.result == null) {
				trace("\t[restclient] NULL response received");	
			} else if (event.result is XML) {
				var xmlresult:XML = XML(event.result) 
				if ("restfault" == xmlresult.name()) {
					// handle restfault
					trace("\t[restclient] RestFault received");
					RestFaultDialog.popup(Sprite(Application.application),new RestFault(event.result));	
				} else if ("reply" == xmlresult.name()) {
					// create Reply first before passing the result
					var reply:Reply = new Reply(xmlresult)
					trace("\t[restclient] " + reply.toString() + " received");
					currentCallback.call(this,reply)				
				} else {
					// pass result as XML
					trace("\t[restclient] XML received");
					currentCallback.call(this,xmlresult);					
				}
			} else if (event.result is ObjectProxy) {
				if (event.result.restfault != null) {		
					// handle restfault
					trace("\t[restclient] RestFault received");
					RestFaultDialog.popup(Sprite(Application.application),event.result.restfault);
				} if (event.result.reply != null) {
					// pass result as Reply
					var xreply:Reply = new Reply()
					xreply.status = event.result.reply.status
					xreply.result = event.result.reply.result
					xreply.messages = event.result.reply.message
					trace("\t[restclient] " + xreply.toString() + " received");
					currentCallback.call(this,xreply);	
				} else {
					// pass result by event
					trace("\t[restclient] Object received");
					currentCallback.call(this,event);				
				}
			} else if (event.result is String) {
				var resultString:String = String(event.result);
				if (resultString == "") {
					trace("\t[restclient] EMPTY received");													
				} else {
					trace("\t[restclient] Object received");
					currentCallback.call(this,event);
				}				
			}
			this.currentCallback = null;
		}
		private function handleFaultReceived(event:FaultEvent):void {
			trace("\t[restclient] FAULT event thrown");
			var fault:RestFault = new RestFault(null)
			fault.code = event.fault.faultCode
			fault.request = event.fault.faultString
			fault.message = event.fault.message.slice(0,30)
			fault.controller = "not applicable"
			fault.method = event.fault.faultString
			fault.stack = event.fault.getStackTrace()
			RestFaultDialog.popup(Sprite(Application.application),fault);
			this.currentCallback = null;
		}		
	}
}