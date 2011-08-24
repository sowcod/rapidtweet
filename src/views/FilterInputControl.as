package views 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author sowcod
	 */
	[Event(name = "change", type = "flash.events.Event")]
	public class FilterInputControl extends Sprite implements IInputControl
	{
		private var _inputTextField:TextField;
		private var _countTextField:TextField;
		
		private var _rightMargin:Number = 32;
		
		public function set countText(text:String):void
		{
			this._countTextField.text = text;
		}
		public function get text():String
		{
			return this._inputTextField.text;
		}
		
		public function FilterInputControl()
		{
			this._inputTextField = this.addChild(this.createInputTextField()) as TextField;
			this._countTextField = this.addChild(this.createCountTextField()) as TextField;
			
			this._inputTextField.addEventListener(Event.CHANGE, onTextChange);
		}
		
		private function onTextChange(ev:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		public function focus():void 
		{
			this.stage.focus = this._inputTextField;
		}
		
		private function createInputTextField():TextField
		{
			var field:TextField = new TextField();
			field.multiline = true;
			field.wordWrap = true;
			field.textColor = 0xFFFFFF;
			field.background = true;
			field.backgroundColor = 0x002222;
			field.border = false;
			field.type = TextFieldType.INPUT;
			return field;
		}
		private function createCountTextField():TextField
		{
			var field:TextField = new TextField();
			field.multiline = false;
			field.selectable = false;
			field.wordWrap = false;
			field.textColor = 0x33FF33;
			field.type = TextFieldType.DYNAMIC;
			field.autoSize = TextFieldAutoSize.RIGHT;
			field.mouseEnabled = false;
			
			field.text = "";
			
			return field;
		}
		
		public function onResize(bounds:Rectangle):void 
		{
			this.fitTextField(bounds);
		}
		
		private function fitTextField(bounds:Rectangle):void
		{
			this._inputTextField.x = bounds.left;
			this._inputTextField.y = bounds.top;
			this._inputTextField.width = bounds.width - this._rightMargin;
			this._inputTextField.height = bounds.height;
			
			this._countTextField.x = bounds.right - this._rightMargin;
			this._countTextField.y = bounds.top;
			this._countTextField.width = this._rightMargin;
		}
	}

}