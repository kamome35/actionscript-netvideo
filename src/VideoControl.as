package 
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
	
	public class VideoControl extends Sprite 
	{
		private var gui		: VideoControlGuiParam;
		private var param	: VideoParam;
		
		public function VideoControl( param : VideoParam )
		{
			this.param  = param;
			gui = new VideoControlGuiParam();
			var instance: VideoControlGuiFactory = new VideoControlGuiFactory( gui );
			var slash : TextField = new  TextField();
			slash.text = "/";
			slash.autoSize = TextFieldAutoSize.LEFT;
			slash.selectable = false;
            slash.setTextFormat( gui.time.format );
			
			// 描画登録
			addChild( gui.backgrand );
			addChild( gui.line );
			addChild( gui.line2 );
			addChild( gui.pause );
			addChild( gui.top );
			addChild( gui.seek );
			addChild( gui.time );
			addChild( slash );
			addChild( gui.timeTotal );
			addChild( gui.speaker );
			addChild( gui.volume );
			addChild( gui.scale );
			
			// GUI位置
			gui.top.x = gui.start.x + gui.start.width;
			gui.seek.x = gui.top.x + gui.top.width + 5;
			gui.seek.y = gui.seek.height / 2;
			gui.time.x = gui.seek.x + gui.seek.width + 5;
			gui.time.y = ( gui.backgrand.height - gui.time.height ) / 2;
			slash.x = gui.time.x + gui.time.width;
			slash.y = ( gui.backgrand.height - slash.height ) / 2;
			gui.timeTotal.x = slash.x + slash.width;
			gui.timeTotal.y = ( gui.backgrand.height - gui.timeTotal.height ) / 2;
			gui.line.x = gui.timeTotal.x + gui.timeTotal.width + 5;
			gui.speaker.x = gui.line.x + gui.line.width;
			gui.mute.x = gui.line.x + gui.line.width;
			gui.volume.x = gui.speaker.x + gui.speaker.width;
			gui.volume.y = ( gui.backgrand.height - gui.volume.height ) / 2;
			gui.line2.x = gui.volume.x + gui.volume.width + 5;
			gui.scale.x = gui.line2.x + gui.line2.width;
			gui.reduction.x = gui.line2.x + gui.line2.width;
			
			// イベント登録
			gui.start.addEventListener( MouseEvent.MOUSE_UP, startMoveUpEvent );	// 開始ボタン
			gui.pause.addEventListener( MouseEvent.MOUSE_UP, pauseMoveUpEvent );	// 一時停止ボタン
			gui.top.addEventListener( MouseEvent.MOUSE_UP, topMoveUpEvent );		// 初めからボタン
			gui.seek.addEventListener( Event.CHANGE, seekChange );					// シークバー
			gui.seek.addEventListener( Event.ENTER_FRAME, seekEnterFrame );			// シークバー
			gui.seek.addEventListener( MouseEvent.MOUSE_DOWN, seekMoveDownEvent );	// シークバー
			gui.speaker.addEventListener( MouseEvent.MOUSE_UP, speakerMoveUpEvent );// スピーカー
			gui.mute.addEventListener( MouseEvent.MOUSE_UP, muteUpEvent );			// ミュート
			gui.volume.addEventListener( Event.CHANGE, volumeChange );				// ボリューム
			gui.scale.addEventListener( MouseEvent.MOUSE_UP, scaleMoveUpEvent );	// 拡大
			gui.reduction.addEventListener( MouseEvent.MOUSE_UP, reductionMoveUpEvent );// 縮小
		}
		
		private function startMoveUpEvent( event : Event ) : void 
		{
			param.stream.resume();
			addChild( gui.pause );
		}
		
		private function pauseMoveUpEvent( event : Event ) : void 
		{
			param.stream.pause();
			addChild( gui.start );
		}
		
		private function topMoveUpEvent( event : Event ) : void 
		{
			param.stream.seek( 0 );
		}
		
		private function seekMoveDownEvent( event : Event ) : void 
		{
			pauseMoveUpEvent( event );
			
			gui.seek.removeEventListener( Event.ENTER_FRAME, seekEnterFrame );
			
			// マウスアップ時のイベント処理
			var stop:Function = function():void
			{
				startMoveUpEvent( event );
				gui.seek.addEventListener( Event.ENTER_FRAME, seekEnterFrame );
				stage.removeEventListener( Event.MOUSE_LEAVE, stop );
				stage.removeEventListener( MouseEvent.MOUSE_UP, stop );
			};
			
			stage.addEventListener( Event.MOUSE_LEAVE, stop );
			stage.addEventListener( MouseEvent.MOUSE_UP, stop );
		}
		
		private function seekChange( event : Event ) : void 
		{
			param.stream.seek( param.timeTotal * gui.seek.value );
			gui.time.setText( param.timeStream );
		}
		
		private function seekEnterFrame( event : Event ) : void 
		{
			gui.seek.range = param.stream.bytesLoaded / param.stream.bytesTotal;
			gui.seek.spriteValue.x = param.timeStream / param.timeTotal * gui.seek.length;
			gui.time.setText( param.timeStream );
			gui.timeTotal.setText( param.timeTotal );
		}
		
		private function speakerMoveUpEvent( event : Event ) : void 
		{
			param.stream.soundTransform = new SoundTransform( 0 );
			addChild( gui.mute );
		}
		
		private function muteUpEvent( event : Event ) : void 
		{
			param.stream.soundTransform = new SoundTransform( gui.volume.value );
			addChild( gui.speaker );
		}
		
		private function volumeChange( event : Event ) : void 
		{
			param.stream.soundTransform = new SoundTransform( gui.volume.value );
			addChild( gui.speaker );
		}
		
		private function scaleMoveUpEvent( event : Event ) : void 
		{
			stage.displayState = StageDisplayState.FULL_SCREEN;
			addChild( gui.reduction );
		}
		
		private function reductionMoveUpEvent( event : Event ) : void 
		{
			stage.displayState = StageDisplayState.NORMAL;
			addChild( gui.scale );
		}
	}
}