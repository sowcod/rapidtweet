package views.tablecontrol 
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author sowcod
	 */
	[Event(name = "change", type = "flash.events.Event")]
	[Event(name = "mouseDown", type = "flash.events.MouseEvent")]
	public interface ITableCell extends IEventDispatcher
	{
		function get cellHeight():Number;
		function set cellY(y:Number):void;
		function get cellY():Number;
		function set cellVisible(visible:Boolean):void;
		function get cellVisible():Boolean;
		function get sortValue():Number;
		
		function get content():DisplayObject;
		
		function set selected(selected:Boolean):void;
		function get selected():Boolean;
		
		function onChangeWidth(width:Number):void;
		
		function search(string:String):Boolean;
	}
	
}