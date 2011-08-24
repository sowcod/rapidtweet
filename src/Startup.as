package  
{
	import mx.core.WindowedApplication;
	import views.TableWindow;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import mx.events.FlexEvent;
	import spark.components.Window;
	import views.TotalInputWindow;
	
	/**
	 * Main window
	 * @author sowcod
	 */
	public class Startup extends WindowedApplication
	{
		
		public function Startup() 
		{
			this.addEventListener(FlexEvent.APPLICATION_COMPLETE, this.onApplicationComplete);
		}
		
		private function onApplicationComplete(ev:FlexEvent):void
		{
			var window:TotalInputWindow = new TotalInputWindow();
			window.height = 50;
			window.width = 500;
			window.x = 500;
			window.y = 500;
			
			this.close();
		}
		
		private function redrawBase():void
		{
			trace(this.stage.stageWidth + "," + this.stage.stageHeight);
			this.graphics.clear();
			this.graphics.lineStyle(0, 0xFF0000);
			this.graphics.beginFill(0x00aacc);
			this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
			this.graphics.endFill();
		}
		
		private function animate():void
		{
			var r:Number = 0;
			var self:Startup = this;
			var window:NativeWindow = this.stage.nativeWindow;
			this.redrawBase();
			
			this.addEventListener(Event.ENTER_FRAME, function(ev:Event):void
			{
				r += 0.1;
				window.width = 800 + Math.cos(r) * 100;
				//self.redrawBase();
			});
		}
	}

}