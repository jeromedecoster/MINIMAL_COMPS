
package com.bit101.utils.actions 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.HRangeSlider;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Knob;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import com.bit101.components.VRangeSlider;
	import com.bit101.components.VSlider;
	import com.bit101.components.VUISlider;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AbstractAction implements IAction
	{
		protected var args:Array;
		protected var configurator:MinimalConfigurator;
		protected var comp:Component;
		protected var parent:DisplayObjectContainer;
		protected var _valid:Boolean = false;
		
		public function AbstractAction(comp:Component,
									   args:Array,
									   configurator:MinimalConfigurator,
									   parent:DisplayObjectContainer)
		{
			this.comp = comp;
			this.args = args;
			this.configurator = configurator;
			this.parent = parent;
		}
		
		//--------------------------------------
		//  EVENTS
		//--------------------------------------
		
		protected function onEvent(event:Event):void 
		{
			execute();
		}
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		/**
		 * Explode args
		 */
		protected function explode():Boolean
		{
			const number:RegExp = /^[-+]?\d+\.?(\d+)?$/;
			
			var s:String;
			var a:Array;
			var n:int = args.length;
			for (var i:int; i < n; i++)
			{
				s = args[i];
				
				if (s.charAt(0) != "{") s = "{" + s;
				if (s.charAt(s.length - 1) != "}") s += "}";
				
				s = s.substr(1, s.length - 2);
				
				// don't split float value
				if (i > 0 && number.test(s))
				{
					args[i] = [s];
				}
				else
				{
					a = s.split(".");
					args[i] = a;
				}
			}
			
			return args[0].length < 2 ? false : true;
		}
		
		protected function getProperties(c:Component):Array
		{
			if (c is HSlider || c is HUISlider || c is Knob ||
				c is NumericStepper || c is VSlider || c is VUISlider)
			{
				return ["value"];
			}
			else if (c is CheckBox || c is RadioButton)
			{
				return ["selected"];
			}
			else if (c is InputText || c is Text || c is TextArea)
			{
				return ["text"];
			}
			else if (c is HRangeSlider || c is VRangeSlider)
			{
				return ["lowValue", "highValue"];
			}
			else if (c is RotarySelector)
			{
				return ["choice"];
			}
			
			return null;
		}
		
		protected function get eventName():String
		{
			if (comp is CheckBox || comp is PushButton || comp is RadioButton)
			{
				return MouseEvent.CLICK;
			}
			else if (comp is HRangeSlider || comp is HSlider || comp is HUISlider ||
					 comp is InputText || comp is Knob || comp is NumericStepper ||
					 comp is RotarySelector || comp is Text || comp is TextArea ||
					 comp is VRangeSlider || comp is VSlider || comp is VUISlider)
			{
				return Event.CHANGE;
			}
			
			// List = Event.SELECT
			return null;
		}
		
		/**
		 * Return an object with 2 properties: target and property
		 * or return null if an error is detected
		 */
		protected function resolveTarget(arr:Array):Object
		{
			if (arr.length < 2) return null;
			
			var o:Object = {};
			var s:String;
			
			// target
			s = arr[0];
			var c:Component = configurator.getCompById(s);
			if (c != null && s == c.name)
			{
				// target is a component
				o.target = c;
				arr.shift();
			}
			else
			{
				// target is not a component
				o.target = parent;
				if (s == "this")
				{
					arr.shift();
				}
			}
			
			// target property
			o.property = arr.pop();
			
			try
			{
				// target hierarchy
				while (arr.length > 0)
				{
					o.target = o.target[arr.shift()];
				}
			}
			catch(err:Error)
			{
				// target hierarchy error
				return null;
			}
			
			// resolve target/property association
			try
			{
				o.target[o.property];
			}
			catch(error:Error)
			{
				return null;
			}
			
			return o;
		}
		
		/**
		 * Return an object with 1 property: value
		 * or return null if an error is detected
		 */
		protected function resolveValue(resTar:Object, arr:Array):Object
		{
			var o:Object = {};
			var s:String;
			
			if (arr.length == 1)
			{
				if (resTar.target[resTar.property] is Boolean)
				{
					o.value = arr[0] == "true";
				}
				else
				{
					if (arr[0] == "null") o.value = null;
					else if (arr[0] == "NaN") o.value = NaN;
					else o.value = arr[0];
				}
				
				return o;
			}
			
			// target
			s = arr[0];
			var c:Component = configurator.getCompById(s);
			if (c != null && s == c.name)
			{
				// target is a component
				o.target = c;
				arr.shift();
			}
			else
			{
				// target is not a component
				o.target = parent;
				if (s == "this")
				{
					arr.shift();
				}
			}
			
			// target property
			o.property = arr.pop();
			
			try
			{
				// target hierarchy
				while (arr.length > 0)
				{
					o.target = o.target[arr.shift()];
				}
			}
			catch(err:Error)
			{
				// target hierarchy error
				return null;
			}
			
			// resolve target/property association
			try
			{
				o.target[o.property];
			}
			catch(error:Error)
			{
				return null;
			}
			
			try
			{
				if (resTar.target[resTar.property] is Boolean)
				{
					o.value = o.target[o.property] == "true" || o.target[o.property] == true;
				}
				else o.value = o.target[o.property];
			}
			catch(err:Error)
			{
				// value association error
				return null;
			}
			
			return o;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		public function execute():void
		{
		}
		
		public function get valid():Boolean { return _valid; }
	}
}




