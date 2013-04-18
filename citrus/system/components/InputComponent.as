package citrus.system.components {

	import citrus.system.Component;

	/**
	 * An input component, it will inform if the key is down, just pressed or just released.
	 */
	public class InputComponent extends Component {
		
		public var isDoingRight:Boolean = false;
		public var isDoingLeft:Boolean = false;
		public var isDoingDuck:Boolean = false;
		public var isDoingJump:Boolean = false;
		public var justDidJump:Boolean = false;

		public function InputComponent(name:String, params:Object = null) {
			super(name, params);
		}

		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			isDoingRight = _ce.input.isDoing("right");
			isDoingRight = _ce.input.isDoing("left");
			isDoingDuck = _ce.input.isDoing("duck");
			isDoingJump = _ce.input.isDoing("jump");
			justDidJump = _ce.input.justDid("jump");
		}
	}
}
