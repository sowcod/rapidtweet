package views.tablecontrol.cell 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author sowcod
	 */
	public class TableCellBorder extends Sprite
	{
		private var _selected:Boolean;
		private var _selectedBorder:Sprite;
		private var _normalBorder:Sprite;
		
		public function set selected(selected:Boolean):void
		{
			this._selected = selected;
			this._selectedBorder.visible = this._selected;
			this._normalBorder.visible = !this._selected;
		}
		public function get selected():Boolean
		{
			return this._selected;
		}
		public function set borderSize(size:Point):void
		{
			this._selectedBorder.width = size.x;
			this._selectedBorder.height = size.y;
			this._normalBorder.width = size.x;
			this._normalBorder.height = size.y;
		}
		
		public function TableCellBorder() 
		{
			this._selectedBorder = this.addChild(this.createSelectedBorder()) as Sprite;
			this._normalBorder = this.addChild(this.createNormalBorder()) as Sprite;
			
			this.selected = false;
		}
		
		public function createSelectedBorder():Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;
			var w:Number = 100;
			var h:Number = 100;
			g.beginFill(0xFF0000);
			g.drawRect(0, 0, w, h);
			g.drawRect(1, 1, w - 2, h - 2);
			g.endFill();
			
			g.beginFill(0x220000);
			g.drawRect(1, 1, w - 2, h - 2);
			g.endFill();
			
			sprite.scale9Grid = new Rectangle(1, 1, w - 2, w - 2);
			
			return sprite;
		}
		public function createNormalBorder():Sprite
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;
			var w:Number = 100;
			var h:Number = 100;
			g.beginFill(0x00FF00);
			g.drawRect(0, 0, w, h);
			g.drawRect(1, 1, w - 2, h - 2);
			g.endFill();
			
			g.beginFill(0x000000);
			g.drawRect(1, 1, w - 2, h - 2);
			g.endFill();
			
			sprite.scale9Grid = new Rectangle(1, 1, w - 2, w - 2);
			
			return sprite;
		}
	}

}