package views.tablecontrol 
{
	import views.tablecontrol.cell.TableCellBorder;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author sowcod
	 */
	public class TableCell extends Sprite implements ITableCell
	{
		private var _textField:TextField;
		private var _border:TableCellBorder;
		private var _selected:Boolean;
		private var _cellVisible:Boolean;
		private var _date:Date;
		
		public function get cellHeight():Number
		{
			if (this._selected) return this._textField.height * 2;
			else return this._textField.height;
		}
		public function set cellY(y:Number):void
		{
			this.y = y;
		}
		public function get cellY():Number
		{
			return this.y;
		}
		public function set cellVisible(visible:Boolean):void
		{
			this._cellVisible = visible;
			this.visible = visible;
		}
		public function get cellVisible():Boolean
		{
			return this._cellVisible;
		}
		public function get content():DisplayObject
		{
			return this;
		}
		public function set selected(selected:Boolean):void
		{
			this._selected = selected;
			this._border.selected = selected;
			var ev:Event = new Event(Event.CHANGE);
			this.dispatchEvent(ev);
		}
		public function get selected():Boolean
		{
			return this._selected;
			var ev:Event = new Event(Event.CHANGE);
			this.dispatchEvent(ev);
		}
		
		public function set text(text:String):void
		{
			this._textField.text = text;
		}
		public function get text():String
		{
			return this._textField.text;
		}
		public function get sortValue():Number
		{
			return this._date.time;
		}
		
		public function set date(date:Date):void 
		{
			this._date = date;
		}
		public function get date():Date
		{
			return this._date;
		}
		
		public function TableCell() 
		{
			this._border = this.addChild(new TableCellBorder()) as TableCellBorder;
			this._textField = this.addChild(this.createTextField()) as TextField;
			this.cellVisible = true;
		}
		
		private function createTextField():TextField
		{
			var field:TextField = new TextField();
			field.multiline = false;
			field.wordWrap = false;
			field.textColor = 0xFFFFFF;
			field.type = TextFieldType.DYNAMIC;
			field.text = "Test Text";
			field.autoSize = TextFieldAutoSize.LEFT;
			return field;
		}
		
		public function onChangeWidth(width:Number):void
		{
			this._border.borderSize = new Point(width, this.cellHeight);
		}
		public function search(string:String):Boolean
		{
			return this._textField.text.indexOf(string) != -1;
		}
	}

}