package windowbase 
{
	import flash.display.Graphics;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowResize;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author sowcod
	 */
	public class ResizableWindow extends NativeWindow
	{
		private var _border:Sprite;
		private var _rad:Number = 5;
		
		public function get contentsBounds():Rectangle
		{
			var r:Number = this._rad;
			return new Rectangle(r, r, 
				this.stage.stageWidth - r * 2, 
				this.stage.stageHeight - r * 2);
		}
		
		public function ResizableWindow() 
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome = NativeWindowSystemChrome.NONE;
			initOptions.transparent = true;
			super(initOptions);
			this.width = 300;
			this.height = 300;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 24;
			
			this._border = stage.addChild(this.createBorder()) as Sprite;
			this.stage.nativeWindow.addEventListener(
				NativeWindowBoundsEvent.RESIZE, this.onResize);
			
			this._border.addEventListener(MouseEvent.MOUSE_DOWN, this.beginResize);
			
			this.activate();
		}
		
		private function beginResize(ev:MouseEvent):void
		{
			var self:ResizableWindow = this;
			var r:Number = this._rad;
			var r2:Number = r * 2.5;
			
			if (ev.stageX <= r) 
				if (ev.stageY <= r2)
					this.startResize(NativeWindowResize.TOP_LEFT);
				else if (ev.stageY >= this.height - r2)
					this.startResize(NativeWindowResize.BOTTOM_LEFT);
				else
					this.startResize(NativeWindowResize.LEFT);
			else if (ev.stageX >= this.width - r) 
				if (ev.stageY <= r2)
					this.startResize(NativeWindowResize.TOP_RIGHT);
				else if (ev.stageY >= this.height - r2)
					this.startResize(NativeWindowResize.BOTTOM_RIGHT);
				else
					this.startResize(NativeWindowResize.RIGHT);
			else if (ev.stageY <= r)
				if (ev.stageX <= r2)
					this.startResize(NativeWindowResize.TOP_LEFT);
				else if (ev.stageX >= this.width - r2)
					this.startResize(NativeWindowResize.TOP_RIGHT);
				else
					this.startResize(NativeWindowResize.TOP);
			else if (ev.stageY >= this.height - r)
				if (ev.stageX <= r2)
					this.startResize(NativeWindowResize.BOTTOM_LEFT);
				else if (ev.stageX >= this.width - r2)
					this.startResize(NativeWindowResize.BOTTOM_RIGHT);
				else
					this.startResize(NativeWindowResize.BOTTOM);
			else
				this.startMove();
			
		}
		
		protected function onResize(ev:NativeWindowBoundsEvent):void
		{
			this._border.width = ev.afterBounds.width;
			this._border.height = ev.afterBounds.height;
		}
		
		private function createBorder():Sprite
		{
			var sp:Sprite = new Sprite();
			
			var w:Number = this.stage.stageWidth;
			var h:Number = this.stage.stageHeight;
			var r:Number = this._rad;
			var inBounds:Rectangle = this.contentsBounds;
			
			var g:Graphics = sp.graphics;
			g.beginFill(0x3333AA);
			g.drawRoundRect(0, 0, w, h, r);
			g.drawRect(inBounds.x, inBounds.y, inBounds.width, inBounds.height);
			g.endFill();
			
			g.beginFill(0x222222, 1.0);
			g.drawRect(inBounds.x, inBounds.y, inBounds.width, inBounds.height);
			g.endFill();
			
			sp.scale9Grid = new Rectangle(r, r, w - r * 2, h - r * 2);
			
			return sp;
		}
	}

}