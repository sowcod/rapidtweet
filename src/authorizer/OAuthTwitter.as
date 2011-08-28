package authorizer 
{
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import net.sowcod.rapidtweet.authorizer.IApiInterface;
	import org.iotashan.oauth.OAuthConsumer;
	import org.iotashan.oauth.OAuthRequest;
	import org.iotashan.oauth.OAuthSignatureMethod_HMAC_SHA1;
	import org.iotashan.oauth.OAuthToken;
	/**
	 * ...
	 * @author sowcod
	 */
	public class OAuthTwitter implements IApiInterface
	{
		public static const API_URL:String = "https://api.twitter.com/"
		
		public static const REQUEST_TOKEN:String = "oauth/request_token";
		public static const ACCESS_TOKEN:String = "oauth/access_token";
		public static const AUTH:String = "oauth/authorize";
		
		public static const HOME_TIMELINE:String = "statuses/home_timeline";
		
		private var _consumer:OAuthConsumer;
		private var _token:OAuthToken;
		private var _userID:String;
		private var _screenName:String;
		
		public function get oauthConsumer():OAuthConsumer { return this._consumer; }
		public function set oauthConsumer(consumer:OAuthConsumer):void { this._consumer = consumer; }
		
		public function get oauthToken():OAuthToken { return this._token }
		public function set oauthToken(token:OAuthToken):void { this._token = token; }
		
		public function get userID():String { return _userID; }
		public function set userID(value:String):void { _userID = value; }
		
		public function get screenName():String { return _screenName; }
		public function set screenName(value:String):void { _screenName = value; }
		
		public function OAuthTwitter(consumer:OAuthConsumer, token:OAuthToken = null,
				userID:String = null, screenName:String = null)
		{
			this._consumer = consumer;
			this._token = token;
			this._userID = userID;
			this._screenName = screenName;
		}
		
		public function beginRequestToken():URLLoader
		{
			var oauthRequest:OAuthRequest = new OAuthRequest("GET",
					this.getApiUrl(OAuthTwitter.REQUEST_TOKEN, null),
					{ "oauth_version":"1.0" }, this._consumer);
			
			var requestUrl:String = oauthRequest.buildRequest(
					new OAuthSignatureMethod_HMAC_SHA1(), OAuthRequest.RESULT_TYPE_URL_STRING);
			
			var request:URLRequest = new URLRequest(requestUrl);
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			loader.load(request);
			
			return loader;
		}
		
		public function setTokenWithVariables(variables:URLVariables):void
		{
			if ("oauth_token" in variables && "oauth_token_secret" in variables)
			{
				this._token = new OAuthToken(variables["oauth_token"], variables["oauth_token_secret"]);
			}
			if ("user_id" in variables && "screen_name" in variables)
			{
				this._userID = variables["user_id"];
				this._screenName = variables["screen_name"];
			}
		}
		
		public function getAuthorizeUrl():String
		{
			return this.getApiUrl(OAuthTwitter.AUTH, null) + "?oauth_token=" + this._token.key;
		}
		
		public function beginAccessToken(pinCode:String):URLLoader
		{
			var loader:URLLoader = this.beginApiRequest(
					OAuthTwitter.ACCESS_TOKEN,
					{ "oauth_verifier":pinCode }, URLRequestMethod.POST, null);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			return loader;
		}
		
		private function createRequestHeader(oauthRequest:OAuthRequest):URLRequestHeader
		{
            var vars:String = oauthRequest.buildRequest(
                    new OAuthSignatureMethod_HMAC_SHA1(),
                    OAuthRequest.RESULT_TYPE_POST);
			
			var headerParams:Array = [];
			for each (var varset:String in vars.split("&") )
			{
				var pair:Array = varset.split("=", 2);
				headerParams.push(pair[0] + "=\"" + pair[1] + "\"");
			}
			var headerText:String = "OAuth " + headerParams.join(",");

			return new URLRequestHeader("Authorization",headerText);
		}
		
		private function toRequestOptions(options:Object):Object
		{
			if (options == null) options = { };
			var ba:ByteArray = new ByteArray();
			ba.writeObject(options);
			ba.position = 0;
			var newObj:Object = ba.readObject();
			newObj["oauth_version"] = "1.0";
			return newObj;
		}
		
		private function getApiUrl(url:String, format:String = "json"):String
		{
			return OAuthTwitter.API_URL + url + ((format)?"." + format:"");
		}
		
		public function beginApiRequest(url:String, options:Object, method:String, format:String = "json"):URLLoader
		{
			var requestUrl:String = this.getApiUrl(url, format);
            var oauthRequest:OAuthRequest = new OAuthRequest(method,
                    requestUrl, options, this._consumer, this._token);
			var header:URLRequestHeader = this.createRequestHeader(oauthRequest);
			
			var request:URLRequest = new URLRequest(requestUrl);
			request.method = method;
			request.requestHeaders = [header];
			
			return new URLLoader(request);
		}
		
		public function homeTimeline(options:Object = null):URLLoader
		{
			var requestOptions:Object = this.toRequestOptions(options);
			var loader:URLLoader = this.beginApiRequest(OAuthTwitter.HOME_TIMELINE, requestOptions, URLRequestMethod.GET)
			return loader;
		}
	}

}