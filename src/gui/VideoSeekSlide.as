package gui
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class VideoSeekSlide extends VideoControlSlide
	{
		public  var range		: Number = 0.0;
		private var spriteRange	: Sprite;
		
		public function VideoSeekSlide( width : uint )
		{
			super( width );
			graphicValue();
			
			spriteValue.y = spriteBar.height / 2 - spriteValue.height / 2;
			spriteRange.width = 0;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( Event.ENTER_FRAME, onRangeEnterFrame );
		}
		
		private function graphicValue() : void
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( 5, 20, 90 * Math.PI / 180 );
			
			spriteRange = spriteValue;	// 範囲として扱う
			
			spriteValue = new Sprite();
			spriteValue.graphics.lineStyle( 1, 0x333333 );
			spriteValue.graphics.beginGradientFill( "linear", [0xFFFFFF, 0xDDDDDD, 0x999999, 0xDDDDDD, 0xFFFFFF], [1.0, 1.0, 1.0, 1.0, 1.0], [0, 107, 127, 17, 255], matrix );
			spriteValue.graphics.drawRect( -2.5, 0, 5, 20 );
			spriteValue.graphics.endFill();
			addChild( spriteValue );
		}
		
		private function onMouseDown( event : MouseEvent ):void
		{
			onMouseMove( event );
			onEnterFrame( event );
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			// マウスアップ時のイベント処理
			var stop:Function = function():void
			{
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			};
			
			stage.addEventListener( Event.MOUSE_LEAVE, stop );
			stage.addEventListener( MouseEvent.MOUSE_UP, stop );
		} 
		
		private function onMouseMove( event:Event ):void
		{
			var limit_length : uint = (length - 1) * range;
			if ( mouseX > limit_length )
			{
				spriteValue.x = limit_length;
			}
			else if ( mouseX <= 0 )
			{
				spriteValue.x = 0;
			}
			else
			{
				spriteValue.x = mouseX;
			}
		}
		
		private function onEnterFrame( event : Event ):void
		{
			value = spriteValue.x / (length - 1);
			
			dispatchEvent( new Event(Event.CHANGE) );
		}
		
		private function onRangeEnterFrame( event : Event ):void
		{
			spriteRange.width = (length - 1) * range;
			if ( range >= 1 )
			{
				removeEventListener( Event.ENTER_FRAME, onRangeEnterFrame );
			}
		}
	}
}
