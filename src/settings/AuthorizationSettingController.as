package settings 
{
	import authorizer.OAuthAuthorizer;
	import flash.events.Event;
	import mx.events.FlexEvent;
	import net.sowcod.rapidtweet.authorizer.AuthorizeEvent;
	import net.sowcod.rapidtweet.authorizer.IApiInterface;
	import net.sowcod.rapidtweet.authorizer.IAuthorizer;
	import spark.components.NavigatorContent;
	import spark.components.TextInput;
	import settings.AuthorizationSetting;
	import spark.components.Window;
	/**
	 * ...
	 * @author sowcod
	 */
	public class AuthorizationSettingController extends Window
	{
		private var _instance:AuthorizationSetting
		private var _screenName:TextInput;
		private var _apiInterface:IApiInterface;
		public function get apiInterface():IApiInterface
		{
			return this._apiInterface;
		}
		
		public function AuthorizationSettingController() 
		{
			this._apiInterface = null;
			this.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, this.onCreationComplete);
		}
		
		private function onCreationComplete(ev:FlexEvent):void
		{
			this.removeEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, arguments.callee);
			
			this._instance = ev.currentTarget as AuthorizationSetting;
			this._screenName = this._instance.screen_name;
		}
		public function clearAuthorization(ev:Event):void
		{
			this.currentState = 'default';
			this._apiInterface = null;
			this._screenName.text = "";
		}
		
		public function beginAuthorization(ev:Event):void
		{
			this._screenName.text = "";
			this.enabled = false;
			var auth:IAuthorizer = new OAuthAuthorizer();
			auth.addEventListener(AuthorizeEvent.AUTHORIZATION_COMPLETED, this.finishAuthorization);
			
			auth.begin();
		}
		
		public function finishAuthorization(ev:AuthorizeEvent):void
		{
			this.enabled = true;
			this.currentState = "authorized";
			
			var auth:IAuthorizer = ev.currentTarget as IAuthorizer;
			var api:IApiInterface = auth.apiInterface;
			this._apiInterface = auth.apiInterface;
			this._screenName.text = api.screenName;
		}
	}

}