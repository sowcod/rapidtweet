package settings 
{
	import authorizer.OAuthAuthorizer;
	import flash.events.Event;
	import mx.binding.utils.BindingUtils;
	import mx.core.Window;
	import mx.events.FlexEvent;
	import net.sowcod.rapidtweet.authorizer.AuthorizeEvent;
	import net.sowcod.rapidtweet.authorizer.IAuthorizer;
	/**
	 * ...
	 * @author sowcod
	 */
	public class SettingWindowController extends Window
	{
		private var _instance:SettingWindow;
		private var _applicationSetting:ApplicationSetting;
		
		public function get applicationSetting():ApplicationSetting { return this._applicationSetting; }
		public function set applicationSetting(applicationSetting:ApplicationSetting):void {
			this._applicationSetting = applicationSetting;
		}
		
		public function SettingWindowController() 
		{
			this.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, this.onCreationComplete);
		}
		
		private function onCreationComplete(ev:Event):void
		{
			this._instance = ev.currentTarget as SettingWindow;
			//BindingUtils.bindProperty(this.applicationSetting, "apiInterface", this._instance.auth_setting, "apiInterface");
		}
	}

}