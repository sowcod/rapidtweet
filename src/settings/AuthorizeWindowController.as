package settings 
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
	import settings.AuthorizeWindow;
	/**
	 * ...
	 * @author sowcod
	 */
	public class AuthorizeWindowController extends Window
	{
		public static var REQUEST_TOKEN_URL:String = "http://twitter.com/oauth/request_token";
		public static var ACCESS_TOKEN_URL:String = "http://twitter.com/oauth/access_token";
		public static var AUTH_URL:String = "http://twitter.com/oauth/authorize";
		
		private var _instance:AuthorizeWindow;
		//private var _htmlProgress:ProgressBar;
		private var _htmlControl:HTML;
		private var _pinCode:TextInput;
		
		private var _consumer:OAuthConsumer = new OAuthConsumer(
				"CKL6oXhNtq3QDBZ6DdKygw", //consumerKey
				"7YPj1WwS5uNaZB12uHHOWzyn2oTREBItSLpqP44lI" //consumerSecret
				);

        public function get pinCode():String
        {
            return this._pinCode.text;
        }
		
		public function AuthorizeWindowController() 
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, this.onComplete);
		}
		
		private function onComplete(ev:FlexEvent):void
		{
			this._instance = ev.currentTarget as AuthorizeWindow;
            //this._htmlProgress = this._instance.html_progress as ProgressBar;
			this._htmlControl = this._instance.html_control as HTML;
			this._pinCode = this._instance.pin_code as TextInput;
		
			this._htmlControl.addEventListener(Event.LOCATION_CHANGE, this.onLocationChange);
			
			this.beginGetAuthorizeUrl();
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, arguments.callee);
			
			this.addEventListener(Event.CLOSE, this.onClose);
		}
		
		private function onClose(ev:Event):void
		{
			this.removeEventListener(Event.CLOSE, arguments.callee);
			
			this._htmlControl.removeEventListener(Event.LOCATION_CHANGE, this.onLocationChange);
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
		
		private function beginGetAuthorizeUrl():void
		{
			var requestUrl:String = this.getRequestTokenUrl();
			
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(requestUrl);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, this.finishGetAuthorizeUrl);
            //this._htmlProgress.source = loader;
			loader.load(new URLRequest(requestUrl));
		}
		
		private function finishGetAuthorizeUrl(ev:Event):void
		{
			var loader:URLLoader = ev.target as URLLoader;
			var variables:URLVariables = loader.data as URLVariables;
			
            /*
			for (var key:String in variables) {
				trace(key, variables[key]);
			}
            */
			
			var url:String = AuthorizeWindowController.AUTH_URL + "?oauth_token=" + variables["oauth_token"];
			this._htmlControl.location = url;
			
			loader.removeEventListener(Event.COMPLETE, arguments.callee);
		}
		
		private function getRequestTokenUrl():String
		{
			var request:OAuthRequest = new OAuthRequest("GET", 
					AuthorizeWindowController.REQUEST_TOKEN_URL,
					{ "oauth_version":"1.0" }, this._consumer);
			
			var url:String = request.buildRequest(new OAuthSignatureMethod_HMAC_SHA1(), OAuthRequest.RESULT_TYPE_URL_STRING);
			
			return url;
		}

        private function authorize():void
        {
            var oauthRequest:OAuthRequest = new OAuthRequest("POST",
                    AuthorizeWindowController.ACCESS_TOKEN_URL,
                    { "oauth_version":"1.0", "verifier":this.pinCode }, this._consumer);
            var request:URLRequestHeader = oauthRequest.buildRequest(
                    new OAuthSignatureMethod_HMAC_SHA1(),
                    OAuthRequest.RESULT_TYPE_HEADER);
            // TODO
        }
	}

}
