package net.sowcod.rapidtweet.authorizer 
{
	import flash.net.URLLoader;
	
	/**
	 * ...
	 * @author sowcod
	 */
	public interface IApiInterface 
	{
		function homeTimeline(options:Object):URLLoader;
	}
	
}