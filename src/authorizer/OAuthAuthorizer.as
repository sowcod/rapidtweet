package authorizer 
{
	import authorizer.AuthorizeWindow;
	import authorizer.SimpleProgressWindow;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import net.sowcod.rapidtweet.authorizer.AuthorizeEvent;
	import net.sowcod.rapidtweet.authorizer.IAuthorizer;
	import net.sowcod.rapidtweet.authorizer.IApiInterface;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	/**
	 * ...
	 * @author sowcod
	 */
	public class OAuthAuthorizer extends EventDispatcher implements IAuthorizer
	{
		private var _oauth:OAuthTwitter;
		
		private var _authorizeWindow:AuthorizeWindow;
		
		public function get apiInterface():IApiInterface
		{
			return this._oauth;
		}
		
		public function OAuthAuthorizer() 
		{
			var consumer:OAuthConsumer = new OAuthConsumer(
				"CKL6oXhNtq3QDBZ6DdKygw", //consumerKey
				"7YPj1WwS5uNaZB12uHHOWzyn2oTREBItSLpqP44lI" //consumerSecret
			);
			this._oauth = new OAuthTwitter(consumer);
		}
		
		public function begin():void
		{
			this.beginGetAuthorizeUrl();
		}
		
		public function cancel():void
		{
			
		}
		
		/**
		 * step1.
		 * get authorization page url.
		 */
		private function beginGetAuthorizeUrl():void
		{
			// create url for reqeust token;
			var loader:URLLoader = this._oauth.beginRequestToken();
			
			loader.addEventListener(Event.COMPLETE, this.finishGetAuthorizeUrl);
			
			var progressWindow:SimpleProgressWindow = new SimpleProgressWindow();
			loader.addEventListener(Event.COMPLETE, function(ev:Event):void {
				progressWindow.close();
			});
			progressWindow.open();
		}
		
		/**
		 * step2.
		 * show authorization page.
		 * @param	ev
		 */
		private function finishGetAuthorizeUrl(ev:Event):void
		{
			var loader:URLLoader = ev.target as URLLoader;
			var variables:URLVariables = loader.data as URLVariables;
			
			this._oauth.setTokenWithVariables(variables);
			
			var url:String = this._oauth.getAuthorizeUrl();
			
			var window:AuthorizeWindow = new AuthorizeWindow();
			window.addEventListener(Event.CLOSE, this.beginAuthorize);
			window.location = url;
			window.open();
		}
		
		/**
		 * step3.
		 * get api access token.
		 * @param	ev
		 */
		private function beginAuthorize(ev:Event):void 
		{
			var authWindow:AuthorizeWindow = ev.currentTarget as AuthorizeWindow;
			
			var loader:URLLoader = this._oauth.beginAccessToken(authWindow.pinCode);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, function(ev:HTTPStatusEvent):void
			{
				trace('statuscode:' , ev.status);
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(ev:IOErrorEvent):void
			{
				trace(ev.errorID, ev.text);
			});
			loader.addEventListener(Event.COMPLETE, this.finishAuthorize);
			
			var progressWindow:SimpleProgressWindow = new SimpleProgressWindow();
			loader.addEventListener(Event.COMPLETE, function(ev:Event):void {
				progressWindow.close();
			});
			progressWindow.open();
		}
		
		/**
		 * step4.
		 * create api interface class.
		 */
		private function finishAuthorize(ev:Event):void 
		{
			var loader:URLLoader = ev.target as URLLoader;
			var variables:URLVariables = loader.data as URLVariables;
			
			this._oauth.setTokenWithVariables(variables);
			
			this.dispatchEvent(new AuthorizeEvent(AuthorizeEvent.AUTHORIZATION_COMPLETED));
		}
	}

}