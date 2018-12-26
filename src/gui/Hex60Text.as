package gui
{
	import flash.display.Sprite;
    import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

	public class Hex60Text extends Sprite
	{
		private var digit	: int;
		public var format	: TextFormat;
		public var tf		: TextField;
		public var bg		: TextField;
		
		public function Hex60Text( digit : int = 0 )
		{
			this.digit = digit;
			
			format = new TextFormat();			
            format.color = 0xFFFFFF;
            format.font  = "Gulim";
            format.size  = 11.4;
            format.bold  = true;
			
			bg = new  TextField();	
			bg.alpha = 0.1;
			bg.text = Hex60Format( 0, digit );
			bg.autoSize = TextFieldAutoSize.LEFT;
			bg.selectable = false;
            bg.setTextFormat( format );
			
			tf = new  TextField();
			tf.text = "";
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
            tf.setTextFormat( format );
			tf.x = bg.width - tf.width;
			
            addChild( bg );
            addChild( tf );
		}
		
		public function setText( time : int ) : void
		{
			bg.text = Hex60Format( time, digit );
            bg.setTextFormat( format );
			
			tf.text = Hex60Format( time, 0 );
            tf.setTextFormat( format );
			tf.x = bg.width - tf.width;
		}
		
		private function Hex60Format( time : int, digit : int ) : String
		{
			var minute : String = (int)(time / 60);
			var second : String = (int)(time % 60);

			while ( minute.length < digit )
			{
				minute = "0" + minute;
			}
			
			if ( second.length === 1 )
			{
				second = "0" + second;
			}
			
			return minute + ":" + second;
		}
	}
}
