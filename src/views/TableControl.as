package views 
{
	import views.tablecontrol.ITableCell;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextLineMetrics;
	import mx.utils.LinkedList;
	import mx.utils.LinkedListNode;
	/**
	 * TODO: selection and scroll
	 *       keyboard control
	 *       mouse control
	 *       
	 * @author sowcod
	 */
	public class TableControl extends Sprite implements IInputControl
	{
		private var _mask:Sprite;
		private var _content:Sprite;
		
		private var _cells:Vector.<ITableCell> = new Vector.<ITableCell>(); // セル全部
		private var _searchString:String = ""; // 検索文字列
		private var _searchResult:Array = [_cells]; // 検索結果
		private var _boundsWidth:Number = 0; // 表示領域
		private var _boundsHeight:Number = 0; // 表示領域
		private var _selectedCell:ITableCell = null; // 選択中のセル
		
		private var _cellHeight:Number = 0;
		private var _viewedCells:Vector.<ITableCell> = new Vector.<ITableCell>(); // 表示中のセル
		
		public function set scrollTop(y:Number):void 
		{
			this._content.y = - y;
			this.layoutCell();
		}
		public function get scrollTop():Number
		{
			return -this._content.y;
		}
		public function set scrollBottom(y:Number):void
		{
			this._content.y = - y + this._boundsHeight
			this.layoutCell();
		}
		public function get scrollBottom():Number
		{
			return this.scrollTop + this._boundsHeight;
		}
		public function get bottomY():Number
		{
			var visibleCells:Vector.<ITableCell> = this.visibleCells;
			var maxBottom:Number = visibleCells.length * this._cellHeight +
				((visibleCells.indexOf(this._selectedCell) == -1)?0:this._selectedCell.cellHeight - this._cellHeight);
			return Math.max(maxBottom, this._boundsHeight);
		}
		public function get visibleCells():Vector.<ITableCell>
		{
			return this._searchResult[this._searchResult.length - 1];
		}
		private function set cells(cells:Vector.<ITableCell>):void
		{
			this._cells = cells;
			this._searchResult[0] = cells;
		}
		
		public function TableControl() 
		{
			this._mask = this.addChild(this.createMask()) as Sprite;
			this._content = this.addChild(this.createContent()) as Sprite;
			
			this._cellHeight = this.calcCellHeight();
			
			this._content.mask = this._mask;
			this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
		}
		
		private function calcCellHeight():Number
		{
			var field:TextField = new TextField();
			field.text = "Test Text";
			field.autoSize = TextFieldAutoSize.LEFT;
			return field.height;
		}
		
		private function onAddedToStage(ev:Event):void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
			this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
		}
		
		public function addCell(cell:ITableCell):void
		{
			cell.addEventListener(Event.CHANGE, this.onCellSelectionChanged);
			cell.addEventListener(MouseEvent.MOUSE_DOWN, this.onCellMouseDown);
			//cell.cellVisible = true;
			//this._content.addChild(cell.content);
			
			this.mapCells(function(cells:Vector.<ITableCell>, self:TableControl):Vector.<ITableCell>
			{
				cells.push(cell);
				return self.sortCells(cells);
			}, cell);
			this.layoutCell();
		}
		public function removeCell(cell:ITableCell):void
		{
			cell.removeEventListener(Event.CHANGE, this.onCellSelectionChanged);
			cell.removeEventListener(MouseEvent.MOUSE_DOWN, this.onCellMouseDown);
			this.mapCells(function(cells:Vector.<ITableCell>, self:TableControl):Vector.<ITableCell>
			{
				var index:int = cells.indexOf(cell);
				cells.splice(index, 1);
				return cells;
			}, cell);
			if (this._selectedCell == cell) this._selectedCell = null;
			this.layoutCell();
		}
		/**
		 * map all cell list
		 * @param	func function(cells:Vector.<ITableCell>, self:TableControl):Vector.<ITableCell>
		 */
		private function mapCells(func:Function, cell:ITableCell):void
		{
			var self:TableControl = this;
			this._searchResult.map(function(item:Vector.<ITableCell>, index:int, array:Array):Vector.<ITableCell>
			{
				if (index == 0) return item;
				if (item is Vector.<ITableCell> && 
					cell.search(self._searchString.substr(0, index)))
				{
					return func(item, self);
				}
				else return item;
			});
			this.cells = func(this._cells, this);
		}
		
		private function sortCells(cells:Vector.<ITableCell>):Vector.<ITableCell>
		{
			return cells.sort(function(x:ITableCell, y:ITableCell):Number
			{
				return x.sortValue - y.sortValue;
			});
		}
		
		private function onMouseWheel(ev:MouseEvent):void
		{
			var newTop:Number = this.scrollTop - ev.delta * this._cellHeight * 0.9;
			var newBottom:Number = newTop + this._boundsHeight;
			
			if (newTop < 0)
				this.scrollToTop();
			else if (newBottom > this.bottomY)
				this.scrollToBottom();
			else
				this.scrollTop = newTop;
		}
		
		private function onKeyDown(ev:KeyboardEvent):void
		{
			/* up:38
			 * down:40
			 * pageUp:33
			 * pageDown:34
			 * home:36
			 * end:35
			 */
			//trace(ev.keyCode);
			var cells:Vector.<ITableCell> = this.visibleCells;
			var index:int = cells.indexOf(this._selectedCell);
			if (ev.keyCode == 38)
			{
				this.selectCell(cells[Math.max(index - 1, 0)]);
			}
			else if (ev.keyCode == 40)
			{
				this.selectCell(cells[Math.min(index + 1, cells.length - 1)]);
			}
			else if (ev.keyCode == 33)
			{
				this.selectCell(cells[
					Math.max(index - Math.floor(this._boundsHeight / this._cellHeight) + 2, 0)]);
			}
			else if (ev.keyCode == 34)
			{
				this.selectCell(cells[
					Math.min(index + Math.floor(this._boundsHeight / this._cellHeight) - 2, cells.length - 1)]);
			}
			else if (ev.keyCode == 36)
			{
				this.scrollToTop();
			}
			else if (ev.keyCode == 35)
			{
				this.scrollToBottom();
			}
		}
		
		private function onCellMouseDown(ev:MouseEvent):void
		{
			var target:ITableCell = ev.currentTarget as ITableCell;
			this.selectCell(target);
		}
		
		public function selectCell(cell:ITableCell):void
		{
			if (this._selectedCell) this._selectedCell.selected = false;
			this._selectedCell = cell;
			cell.selected = true;
			this.layoutCell();
			this.scrollToCell(cell);
		}
		
		private function onCellSelectionChanged(ev:Event):void
		{
			//this.layoutCell(this._boundsWidth);
		}
		
		public function scrollToCell(cell:ITableCell):void
		{
			var cellTop:Number = this.getCellY(cell);
			var cellBottom:Number = cellTop + cell.cellHeight;
			
			if (cellTop < this.scrollTop)
				this.scrollTop = cellTop;
			else if (cellBottom > this.scrollBottom)
				this.scrollBottom = cellBottom;
		}
		public function scrollToBottom():void
		{
			this.scrollBottom = this.bottomY;
		}
		public function scrollToTop():void
		{
			this.scrollTop = 0;
		}
		
		private function createMask():Sprite
		{
			var mask:Sprite = new Sprite();
			var g:Graphics = mask.graphics;
			g.beginFill(0x00aa00);
			g.drawRect(0, 0, 100, 100);
			g.endFill();
			
			return mask;
		}
		
		private function createContent():Sprite
		{
			var content:Sprite = new Sprite();
			return content;
		}
		
		/**
		 * Implementation IInputControl
		 * @param	bounds
		 */
		public function onResize(bounds:Rectangle):void
		{
			this._mask.x = 0;
			this._mask.y = 0;
			this._mask.width = bounds.width;
			this._mask.height = bounds.height;
			
			this._boundsWidth = bounds.width;
			this._boundsHeight = bounds.height;
			
			this.layoutCell();
		}
		
		private function getNearestResultIndex(string:String):int
		{
			var maxlen:int = Math.min(this._searchString.length, string.length);
			var nearestIndex:int = 0;
			for (var i:int = 1; i <= maxlen; ++i) 
			{
				if (this._searchString.charAt(i - 1) == string.charAt(i - 1))
				{
					if (this._searchResult[i] is Vector.<ITableCell>) 
					{
						nearestIndex = i;
					}
				}
				else
					break;
			}
			return nearestIndex;
		}
		
		public function search(string:String):Number
		{
			var nearestIndex:int = this.getNearestResultIndex(string);
			this._searchResult.length = nearestIndex + 1;
			
			if (string != "" && string.length != nearestIndex)
			{
				this._searchResult[string.length] = 
					(this._searchResult[nearestIndex] as Vector.<ITableCell>).filter(
						function(item:ITableCell, index:int, cells:Vector.<ITableCell>):Boolean
						{
							return item.search(string);
						}
					);
			}
			
			this._searchString = string;
			
			if (this.visibleCells.indexOf(this._selectedCell) != -1)
				this.scrollToCell(this._selectedCell);
			else
			{
				var visibleCells:Vector.<ITableCell> = this.visibleCells;
				if (visibleCells.length > 0)
				{
					var bottomCell:ITableCell = visibleCells[visibleCells.length - 1];
					var bottomY:Number = this.getCellY(bottomCell) + bottomCell.cellHeight;
					if (this.scrollBottom > bottomY) 
						this.scrollToBottom();
				}
				else
					this.scrollToTop();
			}
			
			this.layoutCell();
			
			return this.visibleCells.length;
		}
		
		public function layoutCell():void
		{
			this.hideViewedCells();
			var cells:Vector.<ITableCell> = this.visibleCells;
			var end:int = Math.min(cells.length, Math.ceil(this.scrollBottom / this._cellHeight));
			var begin:int = Math.max(Math.floor(this.scrollTop / this._cellHeight) - 1, 0);
			
			var offset:Number = 0;
			var selectedIndex:int = cells.indexOf(this._selectedCell);
			if (selectedIndex == -1) selectedIndex = int.MAX_VALUE;
			else offset = this._selectedCell.cellHeight - this._cellHeight;
			
			for (var i:int = begin; i < end; ++i)
			{
				var cell:ITableCell = cells[i];
				this._content.addChild(cell.content);
				cell.cellY = i * this._cellHeight + ((i > selectedIndex)?offset:0);
				cell.onChangeWidth(this._boundsWidth);
				this._viewedCells.push(cell);
			}
		}
		private function getCellY(cell:ITableCell):Number
		{
			var cells:Vector.<ITableCell> = this.visibleCells;
			var cellIndex:Number = cells.indexOf(cell);
			var selectedIndex:int = cells.indexOf(this._selectedCell);
			var offset:Number = 0;
			if (selectedIndex == -1) selectedIndex = int.MAX_VALUE;
			else offset = this._selectedCell.cellHeight - this._cellHeight;
			return cellIndex * this._cellHeight + ((cellIndex > selectedIndex)?offset:0);
		}
		private function hideViewedCells():void
		{
			for each (var cell:ITableCell in this._viewedCells) 
				this._content.removeChild(cell.content);
			this._viewedCells.length = 0;
		}
	}

}