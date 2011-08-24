package views 
{
	import controls.BitmapButton;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	import windowbase.ResizableWindow;
	import settings.SettingWindow;
	/**
	 * ...
	 * @author sowcod
	 */
	public class TotalInputWindow extends ResizableWindow
	{
		private var _tweetInput:TweetInputControl = new TweetInputControl();
		private var _filterInput:FilterInputControl = new FilterInputControl();
		
		private var _tableWindow:TableWindow = new TableWindow();
		
		private var _tweetModeButton:BitmapButton;
		private var _filterModeButton:BitmapButton;
		
		[Embed(source="/assets/tweet.png")]
		private var tweetImgClass:Class
		
		[Embed(source="/assets/filter.png")]
		private var filterImgClass:Class
		
		public function TotalInputWindow() 
		{
			this.stage.addChild(this._tweetInput);
			this._filterInput.visible = false;
			this.stage.addChild(this._filterInput);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			
			this._filterInput.addEventListener(Event.CHANGE, this.onFilterTextChange);
			this.addEventListener(NativeWindowBoundsEvent.MOVE, this.onWindowMove);
			
			this.buttonSetup();
			this.changeMode("tweet");
			
			this.updateBounds();
			
			var settingWindow:SettingWindow = new SettingWindow();
			settingWindow.open();
		}
		
		private function buttonSetup():void
		{
			this._tweetModeButton = this.stage.addChild(new BitmapButton(new tweetImgClass())) as BitmapButton;
			this._filterModeButton = this.stage.addChild(new BitmapButton(new filterImgClass())) as BitmapButton;
			
			this._tweetModeButton.addEventListener(MouseEvent.CLICK, this.onClickModeButton);
			this._filterModeButton.addEventListener(MouseEvent.CLICK, this.onClickModeButton);
		}
		
		private function onClickModeButton(ev:MouseEvent):void
		{
			if (ev.currentTarget == this._tweetModeButton)
				this.changeMode("tweet");
			else if (ev.currentTarget == this._filterModeButton)
				this.changeMode("filter");
		}
		/**
		 * change mode.
		 * mode : "tweet" or "filter"
		 * @param	mode
		 */
		private function changeMode(mode:String):void
		{
			if (mode == "tweet")
			{
				this._tweetModeButton.selected = true;
				this._filterModeButton.selected = false;
				
				this._tweetInput.visible = true;
				this._filterInput.visible = false;
				this._tweetInput.focus();
			}
			else if (mode == "filter")
			{
				this._tweetModeButton.selected = false;
				this._filterModeButton.selected = true;
				
				this._tweetInput.visible = false;
				this._filterInput.visible = true;
				this._filterInput.focus();
			}
		}
		
		override protected function onResize(ev:NativeWindowBoundsEvent):void
		{
			super.onResize(ev);
			
			this.updateBounds();
		}
		
		private function onWindowMove(ev:NativeWindowBoundsEvent):void
		{
			/*
			this._tableWindow.x = ev.afterBounds.left
			this._tableWindow.y = ev.afterBounds.top - this._tableWindow.height;
			*/
		}
		
		private function onFilterTextChange(ev:Event):void
		{
			this._tableWindow.search(this._filterInput.text);
			//var text:String = this._filterInput.text;
			//var count:Number = this._tableWindow.search(this._filterInput.text);
			//this._filterInput.countText = (text == "")?"":count.toString();
		}
		
		private function onKeyDown(ev:KeyboardEvent):void
		{
			// trace(ev.keyCode, ev.ctrlKey, ev.shiftKey);
			// w:87
			// t:84
			// f:70
			if (ev.ctrlKey && ev.shiftKey && ev.keyCode == 84)
			{
				// ctrl + shift + t
				this.changeMode("tweet");
				ev.preventDefault();
			}
			else if (ev.ctrlKey && ev.shiftKey && ev.keyCode == 70)
			{
				// ctrl + shift + t
				this.changeMode("filter");
				ev.preventDefault();
			}
			else if (ev.ctrlKey && ev.shiftKey && ev.keyCode == 87)
			{
				// ctrl + shift + w
				this._tableWindow.activate();
				ev.preventDefault();
			}
		}
		private function updateBounds():void
		{
			var bounds:Rectangle = this.contentsBounds;
			
			this._tweetInput.onResize(bounds);	
			this._filterInput.onResize(bounds);
			
			this._filterModeButton.x = bounds.right - this._filterModeButton.width;
			this._filterModeButton.y = bounds.bottom - this._filterModeButton.height;
			this._tweetModeButton.x = this._filterModeButton.x - this._filterModeButton.width;
			this._tweetModeButton.y = bounds.bottom - this._tweetModeButton.height;
		}
	}

}