package  {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import com.quetwo.Arduino.ArduinoConnector;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	public class Main extends Sprite{

		private var _arduinoConnector:ArduinoConnector = new ArduinoConnector();
		private var _textField:TextField = new TextField();
		private var _comPortList:List;
		private var _leonardeCheck:CheckBox;
		public function Main() {
			init();
		}
		
		private function init():void {
			_textField.border = true;
			_textField.height = 400;
			addChild(_textField);
			
			if (_arduinoConnector.isSupported()) {
				addUI();
				//comm();
			}
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDown);
			
			var nativeApplication:NativeApplication = NativeApplication.nativeApplication;
			nativeApplication.addEventListener(Event.EXITING, nativeApplication_exiting);
		}
		
		private function nativeApplication_exiting(e:Event):void 
		{
			_arduinoConnector.dispose();
		}
		
		private function stage_mouseDown(e:MouseEvent):void 
		{
			// 時刻を書きこむ
			_arduinoConnector.writeString(new Date().toTimeString());
		}
		
		private function addUI():void {
			var items:Array = _arduinoConnector.getComPorts();
			_comPortList = new List(this, 120, 8, items);
			_comPortList.selectedIndex = 0;
			
			_leonardeCheck = new CheckBox(this, 120, 120, "is Leonarde");
			_leonardeCheck.selected = true;
			
			new PushButton(this, 120, 170, "Start", onStart);
		}
		
		private function onStart(e:Event):void {
			
			(e.target as PushButton).enabled = false;
			_comPortList.enabled = false;
			_leonardeCheck.enabled = false;
			
			//trace(_comPortList.selectedItem, _leonardeCheck.selected);
			// comPortは要書き換え
			var comPort:String = _comPortList.selectedItem.toString();// "COM3";
			var baud:int = 9600;
			var useDtrControl:Boolean = _leonardeCheck.selected;
			// Leonardo系の場合は、第三引数をtrueにする。
			// http://www.viva-mambo.co.jp/jp/labo/2014/07/arduino-leopardo.html
			_arduinoConnector.connect(comPort, baud, useDtrControl);
			_arduinoConnector.addEventListener("socketData", arduinoConnector_socketdata);
		}
		
		private function arduinoConnector_socketdata(e:Event):void 
		{
			// 送られてきた文字を表示
			_textField.appendText(_arduinoConnector.readBytesAsString());
		}
	}
}