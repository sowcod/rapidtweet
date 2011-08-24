package controls 
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author sowcod
	 */
	public class BitmapButton extends Sprite
	{
		private var _bitmap:Bitmap;
		private var _normalBorder:Sprite;
		private var _selectedBorder:Sprite;
		
		public function set selected(selected:Boolean):void
		{
			this._normalBorder.visible = !selected;
			this._selectedBorder.visible = selected;
		}
		
		public function BitmapButton(bitmap:Bitmap) 
		{
			var w:Number = bitmap.width;
			var h:Number = bitmap.height;
			this._normalBorder = this.createBorder(w, h, 0x005555, 0x000000);
			this._selectedBorder = this.createBorder(w, h, 0x55ffff, 0x003333);
			this._selectedBorder.visible = false;
			
			this.addChild(this._normalBorder);
			this.addChild(this._selectedBorder);
			
			this._bitmap = this.addChild(bitmap) as Bitmap;
			
			this.buttonMode = true;
		}
		
		private function createBorder(width:Number, height:Number, lineColor:uint, backColor:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			var g:Graphics = sp.graphics;
			
			g.beginFill(lineColor);
			g.drawRect(0, 0, width, height);
			g.drawRect(1, 1, width - 2, height - 2);
			g.endFill();
			
			g.beginFill(backColor);
			g.drawRect(1, 1, width - 2, height - 2);
			g.endFill();
			
			return sp;
		}
	}

}