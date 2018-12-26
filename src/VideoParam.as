package 
{
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.NetStream;
    import flash.media.Video;
	/**
	 * ビデオパラメータ構造体
	 * FLV,MP4...etc.再生に必要な情報を管理する構造体
	 */
	public class VideoParam
	{
		public var connect		: NetConnection;	// Flash Video (FLV) ファイル再生
		public var stream		: NetStream;		// ストリーミング接続
		public var video		: Video;			// ビデオ
		public var timeTotal	: Number;			// ファイル総時間
		public var timeStream	: Number;			// シーク時間
		public var path 		: String;			// ファイルパス
		
		public function VideoParam() : void 
		{
			this.connect	= null;
			this.stream		= null;
			this.video		= null;
			this.timeTotal	= 0;
			this.path		= "";
		}
	}
	
}