package authorizer 
{
	import flash.events.Event;
	import flash.html.HTMLLoader;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import mx.controls.HTML;
	import mx.controls.ProgressBar;
	import mx.events.FlexEvent;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import spark.components.TextInput;
	import spark.components.Window;
	/**
	 * ...
	 * @author sowcod
	 */
	public class AuthorizeWindowController extends Window
	{
		private var _instance:AuthorizeWindow;
		//private var _htmlProgress:ProgressBar;
		private var _htmlControl:HTML;
		private var _pinCode:TextInput;
		private var _location:String;

        public function get pinCode():String
        {
            return this._pinCode.text;
        }
		public function set location(url:String):void
		{
			this._location = url;
			if (this._htmlControl) this._htmlControl.location = url;
		}
		
		public function AuthorizeWindowController() 
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, this.onComplete, false, 0, true);
		}
		
		private function onComplete(ev:FlexEvent):void
		{
			this._instance = ev.currentTarget as AuthorizeWindow;
            //this._htmlProgress = this._instance.html_progress as ProgressBar;
			this._htmlControl = this._instance.html_control as HTML;
			this._pinCode = this._instance.pin_code as TextInput;
		
			this._htmlControl.addEventListener(Event.LOCATION_CHANGE, this.onLocationChange);
			if (this._location) this._htmlControl.location = this._location;
			
			this.addEventListener(Event.CLOSE, this.onClose, false, 0, true);
		}
		
		private function onClose(ev:Event):void
		{
		}
		
		private function onLocationChange(ev:Event):void
		{
			var loader:HTMLLoader = (ev.target as HTML).htmlLoader;
			var pinCode:TextInput = this._pinCode;
			
			loader.addEventListener(Event.COMPLETE, function(ev:Event):void 
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				
				var codes:* = loader.window.document.getElementsByTagName("code");
				if (codes.length) pinCode.text = codes[0].innerText;
			});
		}
	}

}
