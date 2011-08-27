package net.sowcod.rapidtweet.authorizer 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author sowcod
	 */
	public class AuthorizeEvent extends Event
	{
		public static const AUTHORIZATION_COMPLETED:String = "authorizationCompleted";
		public static const AUTHORIZATION_FAILED:String = "authorizationFailed";
		
		public function AuthorizeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
	}

}