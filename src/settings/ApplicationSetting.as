package settings 
{
	import net.sowcod.rapidtweet.authorizer.IApiInterface;
	/**
	 * ...
	 * @author sowcod
	 */
	public class ApplicationSetting 
	{
		private var _apiInterface:IApiInterface;
		
		[Bindable]
		public function get apiInterface():IApiInterface { return _apiInterface; }
		public function set apiInterface(value:IApiInterface):void { _apiInterface = value; }
		
		public function ApplicationSetting() 
		{
			
		}
		
	}

}