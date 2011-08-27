package net.sowcod.rapidtweet.authorizer 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Do authorization and create api interface.
	 * @author sowcod
	 */
	[Event(name = "authorizationCompleted", type = "net.sowcod.rapidtweet.authorizer.AuthorizeEvent")]
	[Event(name = "authorizationFailed", type = "net.sowcod.rapidtweet.authorizer.AuthorizeEvent")]
	public interface IAuthorizer extends IEventDispatcher
	{
		function get apiInterface():IApiInterface;
		
		/**
		 * Begin authorization and dispatch "authorizationComplete" or "authorizationFail" event later.
		 */
		function begin():void;
		
		/**
		 * cancel authorization and dispatch "authorizationFail" event.
		 */
		function cancel():void;
	}
	
}