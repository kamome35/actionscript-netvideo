package gui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class VideoControlButton extends Sprite
	{
		private var bg : Sprite;
		private var icon : Sprite;
		public function VideoControlButton( icon : Sprite )
		{
			this.icon = icon;
			
			ButtonStyle( icon, 0x666666, 0x222222 );
			
			this.icon.mouseEnabled
			
			addEventListener( MouseEvent.MOUSE_OUT,  onMouseOut );
			addEventListener( MouseEvent.MOUSE_UP,   onMouseOver );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		}
		
		private function ButtonStyle(  icon : Sprite, Color1 : uint,  Color2 : uint ) : void
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( 25, 25, 90 * Math.PI / 180 );
			
			bg = new Sprite();
			bg.graphics.beginGradientFill( "linear", [Color1, Color2, Color1], [1.0, 1.0, 1.0], [0, 127, 255], matrix );
			bg.graphics.drawRect( 0, 0, 25, 25 );
			bg.graphics.endFill();
			bg.graphics.lineStyle( 1.0, 0xAAAAAA );
			bg.graphics.moveTo( 0, 0 );
			bg.graphics.lineTo( 25, 0 );
			bg.graphics.lineStyle( 1.0, 0x222222 );
			bg.graphics.moveTo( 25, 25 );
			bg.graphics.lineTo( 0, 25 );
			addChild( bg );
			
			icon.x = bg.width / 2 - icon.width / 2;
			icon.y = bg.height / 2 - icon.height / 2;
			addChild( icon );
		}
	
		private function onMouseOut( event:MouseEvent ) : void
		{
			ButtonStyle( icon, 0x666666, 0x222222 );
		}
	 
		private function onMouseDown( event:MouseEvent ) : void
		{
			ButtonStyle( icon, 0x666666, 0xAAAAAA );
		}
	 
		private function onMouseOver( event:MouseEvent ) : void
		{
			ButtonStyle( icon, 0x666666, 0x444444 );
		}
	} 

}