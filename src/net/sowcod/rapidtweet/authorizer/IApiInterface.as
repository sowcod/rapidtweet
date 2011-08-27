package net.sowcod.rapidtweet.authorizer 
{
	import flash.net.URLLoader;
	
	/**
	 * ...
	 * @author sowcod
	 */
	public interface IApiInterface 
	{
		function get userID():String;
		function get screenName():String;
		function homeTimeline(options:Object = null):URLLoader;
	}
	
}