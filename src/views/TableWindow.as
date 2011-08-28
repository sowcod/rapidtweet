package views 
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import net.sowcod.rapidtweet.authorizer.IApiInterface;
	import settings.ApplicationSetting;
	import views.tablecontrol.TableCell;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import windowbase.ResizableWindow;
	/**
	 * ...
	 * @author sowcod
	 */
	public class TableWindow extends ResizableWindow
	{
		private var _tableControl:TableControl;
		private var _leftMargin:Number = 10;
		private var _applicationSetting:ApplicationSetting;
		[Bindable]
		public var apiInterface:IApiInterface;
		
		public function get applicationSetting():ApplicationSetting { return _applicationSetting; }
		public function set applicationSetting(value:ApplicationSetting):void { _applicationSetting = value; }
		
		public function TableWindow() 
		{
			this._tableControl = this.stage.addChild(new TableControl()) as TableControl;
			this._tableControl.x = this.contentsBounds.x + this._leftMargin;
			this._tableControl.y = this.contentsBounds.y;
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			
			this.updateBounds();
			/*
			var cells:Array = [];
			for (var i:int = 0; i < 100; ++i)
			{
				cells.push(this.addSampleCell(i));
			}
			
			var timer:Timer = new Timer(300);
			var self:TableWindow = this;
			timer.addEventListener(TimerEvent.TIMER, function(ev:TimerEvent):void
			{
				cells.push(self.addSampleCell(i++));
			});
			timer.start();
			
			var timer2:Timer = new Timer(300, 100);
			timer2.addEventListener(TimerEvent.TIMER, function(ev:TimerEvent):void
			{
				var cell:TableCell = cells.splice(Math.floor(Math.random() * cells.length), 1)[0];
				self._tableControl.removeCell(cell);
			});
			timer2.start();
			*/
			/*
			var timelineTimer:Timer = new Timer(300000);
			var self:TableWindow = this;
			timelineTimer.addEventListener(TimerEvent.TIMER, function(ev:TimerEvent):void
			{
				self.updateTimeline();
			});
			timelineTimer.start();
			*/
			this.updateTimeline();
		}
		private function onKeyDown(ev:KeyboardEvent):void
		{
			if (ev.keyCode == 116)
			{
				this.updateTimeline();
			}
		}
		
		private function updateTimeline():void
		{
			trace("update", this.apiInterface);
			if (!this.apiInterface) return;
			var api:IApiInterface = this.apiInterface;
			var self:TableWindow = this;
			api.homeTimeline().addEventListener(Event.COMPLETE, function (ev:Event):void 
			{
				var loader:URLLoader = ev.currentTarget as URLLoader;
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				
				var alldata:Object = JSON.decode(loader.data);
				for each (var tweet:Object in alldata)
				{
					self.addTweetCell(tweet);
				}
			});
		}
		
		private function addTweetCell(tweet:Object):TableCell
		{
			var cell:TableCell = new TableCell();
			cell.cellID = tweet["id"];
			cell.text = tweet["text"];
			this._tableControl.addCell(cell);
			return cell;
		}
		
		private function addSampleCell(num:int):TableCell
		{
			var cell:TableCell = new TableCell();
			switch (Math.floor(Math.random() * 5)) 
			{
				case 0:
					cell.text = "abcd";
					break;
				case 1:
					cell.text = "bcde";
					break;
				case 2:
					cell.text = "cdef";
					break;
				case 3:
					cell.text = "あいうえ";
					break;
				case 4:
					cell.text = "うえおか";
					break;
			}
			cell.cellID = (new Date()).time;
			cell.text += num;
			this._tableControl.addCell(cell);
			return cell;
		}
		
		public function search(string:String):Number
		{
			return this._tableControl.search(string);
		}
		
		override protected function onResize(ev:NativeWindowBoundsEvent):void 
		{
			super.onResize(ev);
			
			this.updateBounds();
		}
		
		private function updateBounds():void
		{
			var newBounds:Rectangle = this.contentsBounds.clone();
			newBounds.left += this._leftMargin;
			this._tableControl.onResize(newBounds);
		}
		
	}

}