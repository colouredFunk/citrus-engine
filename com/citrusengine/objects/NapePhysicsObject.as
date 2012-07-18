package com.citrusengine.objects {

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.physics.Nape;
	import com.citrusengine.view.ISpriteView;
	
	import flash.display.MovieClip;
	
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
    import nape.shape.Polygon;

	/**
	 * You should extend this class to take advantage of Nape. This class provides template methods for defining
	 * and creating Nape bodies, fixtures, shapes, and joints. If you are not familiar with Nape, you should first
	 * learn about it via the <a href="http://deltaluca.me.uk/docnew/">Nape Documentation</a>.
	 */	
	public class NapePhysicsObject extends CitrusObject implements ISpriteView {
		
		public static const PHYSICS_OBJECT:CbType = new CbType();
		
		protected var _ce:CitrusEngine;
		protected var _nape:Nape;
		protected var _body:Body;
		protected var _bodyType:BodyType;
		protected var _material:Material;
		
		protected var _inverted:Boolean = false;
		protected var _parallax:Number = 1;
		protected var _animation:String = "";
		protected var _visible:Boolean = true;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _view:* = MovieClip;
		protected var _rotation:Number = 0;
		protected var _width:Number = 1;
		protected var _height:Number = 1;
		protected var _radius:Number;
		
		private var _group:Number = 0;
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		private var _registration:String = "center";

		public function NapePhysicsObject(name:String, params:Object = null) {
			
			super(name, params);
			
			_ce = CitrusEngine.getInstance();
			_nape = _ce.state.getFirstObjectByType(Nape) as Nape;
			
			if (!_nape) {
				throw new Error("Cannot create PhysicsObject when a Nape object has not been added to the state.");
				return;
			}
			
			//Override these to customize your Nape initialization. Things must be done in this order.
			defineBody();
			createBody();
			createMaterial();
			createShape();
			createConstraint();
		}
		
		override public function destroy():void {
			
			_nape.space.bodies.remove(_body);
			
			super.destroy();
		}
		
		/**
		 * You should override this method to extend the functionality of your physics object. This is where you will 
		 * want to do any velocity/force logic. 
		 */		
		override public function update(timeDelta:Number):void {
		}
		
		public function handleBeginContact(callback:InteractionCallback):void {
		}
		
		public function handleEndContact(callback:InteractionCallback):void {
		}
		
		protected function defineBody():void {
			
			_bodyType = BodyType.DYNAMIC;
		}
		
		protected function createBody():void {
			
			_body = new Body(_bodyType, new Vec2(_x + _width / 2, _y + _height / 2));
			_body.userData.myData = this;
		}
		
		protected function createMaterial():void {
			
			_material = new Material(0.2, 1, 1, 1, 0);
		}
		
		protected function createShape():void {
			
			if (_radius) {
				_body.shapes.add(new Circle(_radius, null, _material));
			} else {
				_body.shapes.add(new Polygon(Polygon.box(_width, _height), _material));				
			}
			
			_body.rotate(new Vec2(_x + _width / 2, _y + _height / 2), _rotation);
		}
		
		protected function createConstraint():void {
			
			_body.space = _nape.space;			
			_body.cbTypes.add(PHYSICS_OBJECT);
		}
		
		public function get x():Number
		{
			if (_body)
				return _body.position.x;
			else
				return _x;
		}
		
		[Property(value="0")]
		public function set x(value:Number):void
		{
			_x = value;
			
			if (_body)
			{
				var pos:Vec2 = _body.position;
				pos.x = _x;
				_body.position = pos;
			}
		}
			
		public function get y():Number
		{
			if (_body)
				return _body.position.y;
			else
				return _y;
		}
		
		[Property(value="0")]
		public function set y(value:Number):void
		{
			_y = value;
			
			if (_body)
			{
				var pos:Vec2 = _body.position;
				pos.y = _y;
				_body.position = pos;
			}
		}
			
		public function get parallax():Number
		{
			return _parallax;
		}
		
		[Property(value="1")]
		public function set parallax(value:Number):void
		{
			_parallax = value;
		}
		
		public function get rotation():Number
		{
			if (_body)
				return _body.rotation * 180 / Math.PI;
			else
				return _rotation * 180 / Math.PI;
		}
		
		[Property(value="0")]
		public function set rotation(value:Number):void
		{
			_rotation = value * Math.PI / 180;
			
			if (_body) {
				_body.rotate(new Vec2(_x + _width / 2, _y + _height / 2), _rotation);
			} 
		}
			
		public function get group():Number
		{
			return _group;
		}
		
		[Property(value="0")]
		public function set group(value:Number):void
		{
			_group = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get view():*
		{
			return _view;
		}
		
		[Property(value="", browse="true")]
		public function set view(value:*):void
		{
			_view = value;
		}
		
		public function get animation():String
		{
			return _animation;
		}
		
		public function get inverted():Boolean
		{
			return _inverted;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		[Property(value="0")]
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		[Property(value="0")]
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		
		public function get registration():String
		{
			return _registration;
		}
		
		[Property(value="topLeft")]
		public function set registration(value:String):void
		{
			_registration = value;
		}
		
		/**
		 * This can only be set in the constructor parameters. 
		 */		
		public function get width():Number
		{
			return _width;
		}
		
		[Property(value="30")]
		public function set width(value:Number):void
		{
			_width = value;
			
			if (_initialized)
			{
				trace("Warning: You cannot set " + this + " width after it has been created. Please set it in the constructor.");
			}
		}
		
		/**
		 * This can only be set in the constructor parameters. 
		 */	
		public function get height():Number
		{
			return _height;
		}
		
		[Property(value="30")]
		public function set height(value:Number):void
		{
			_height = value;
			
			if (_initialized)
			{
				trace("Warning: You cannot set " + this + " height after it has been created. Please set it in the constructor.");
			}
		}
		
		/**
		 * This can only be set in the constructor parameters. 
		 */	
		public function get radius():Number
		{
			return _radius;
		}
		
		/**
		 * The object has a radius or a width & height. It can't have both.
		 */
		[Property(value="")]
		public function set radius(value:Number):void
		{
			_radius = value;
			
			if (_initialized)
			{
				trace("Warning: You cannot set " + this + " radius after it has been created. Please set it in the constructor.");
			}
		}
		
		/**
		 * A direction reference to the Nape body associated with this object.
		 */
		public function get body():Body
		{
			return _body;
		}
	}
}
