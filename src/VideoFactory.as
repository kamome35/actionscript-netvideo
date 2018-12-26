package 
{
	import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	
	/**
	 * ビデオ接続管理
	 * Abstract Factoryパターン
	 * 
	 * @author 
	 */
	public class VideoFactory extends Sprite
	{
		public var param : VideoParam;	// ビデオパラメータ構造体
		
		public function VideoFactory( path : String ) : void 
		{
			param = new VideoParam();
			param.path = path;
		}
		
		public function connect() : void 
		{
            param.connect = new NetConnection();
            param.connect.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
            param.connect.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            param.connect.connect( null );
		}
		
		private function streamStart() : void 
		{
			// ストリーム開始
            param.stream = new NetStream( param.connect );
            param.stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			
			// メタ情報の取得
			var obj:Object = new Object();
			obj.onMetaData = function( info:Object ) : void
			{
				param.timeTotal = info.duration;
			};
            param.stream.client = obj;
			
			// ビデオ
            param.video = new Video( 544, 384 );
            param.video.attachNetStream( param.stream );
			param.video.addEventListener( Event.ENTER_FRAME, timeStreamEnterFrame );
			addChild( param.video );
			
			// 再生開始
            param.stream.play( param.path );
		}
		
		private function netStatusHandler( event : NetStatusEvent ) : void
		{
			switch ( event.info.code )
			{
				case "NetConnection.Connect.Success":
					this.streamStart();
					break;
					
				case "NetStream.Play.StreamNotFound":
					trace( "Stream not found: " + param.path );
					break;
			}
		}
		
		private function securityErrorHandler( event : SecurityErrorEvent ) : void
		{
			trace( "securityErrorHandler: " + event );
		}
		
		private function timeStreamEnterFrame( event : Event ) : void
		{
			param.timeStream = param.stream.time;
		}
	}
	
}