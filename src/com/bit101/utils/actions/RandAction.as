
package com.bit101.utils.actions 
{
	import com.bit101.components.Component;
	import com.bit101.components.HRangeSlider;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Knob;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.VRangeSlider;
	import com.bit101.components.VSlider;
	import com.bit101.components.VUISlider;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.DisplayObjectContainer;

	public class RandAction extends AbstractAction
	{
		protected var integer:Boolean;
		
		public function RandAction(comp:Component,
								   args:Array,
								   configurator:MinimalConfigurator,
								   parent:DisplayObjectContainer,
								   integer:Boolean = true)
		{
			super(comp, args, configurator, parent);
			
			this.integer = integer;
			
			var exp:Boolean = explode();
			if (!exp)
			{
				return;
			}
			
			comp.addEventListener(eventName, onEvent);
			_valid = true;
		}
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		/**
		 * Explode args
		 */
		override protected function explode():Boolean
		{
			if (args.length != 1) return false;
			
			var s:String = args[0];
			
			if (s.charAt(0) != "{") s = "{" + s;
			if (s.charAt(s.length - 1) != "}") s += "}";
			
			s = s.substr(1, s.length - 2);
			
			var c:Component = configurator.getCompById(s);
			if (c == null) return false;
			
			if (c is HSlider || c is HUISlider || c is Knob ||
				c is NumericStepper || c is VSlider || c is VUISlider)
			{
				args[0] = [s, "value"];
				return true;
			}
			else if (c is HRangeSlider || c is VRangeSlider)
			{
				args[0] = [s, "lowValue"];
				return true;
			}
			else if (c is RotarySelector)
			{
				args[0] = [s, "choice"];
				return true;
			}
			
			return false;
		}
		
		private function randInt(min:int, max:int):int
		{
			if (min == max) return min;
			if (min > max) return int(Math.random() * (min - max + 1)) + max;
			return int(Math.random() * (max - min + 1)) + min;
		}
		
		private function randFloat(min:Number, max:Number):Number
		{
			if (isNaN(min) || isNaN(max)) return NaN;
			if (min == max) return min;
			if (min > max) return Math.random() * (min - max) + max;
			return Math.random() * (max - min) + min;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		override public function execute():void
		{
			var resTar:Object = resolveTarget(args[0].slice());
			
			if (resTar == null) return;
			
			// no interface, so cast as *
			var c:* = resTar.target;
			var min:Number;
			var max:Number;
			if (integer)
			{
				if (c is RotarySelector) c.choice = randInt(0, c.numChoices - 1);
				else if (c is HRangeSlider || c is VRangeSlider)
				{
					min = randInt(c.minimum, c.maximum);
					max = randInt(c.minimum, c.maximum);
					c.lowValue = Math.min(min, max);
					c.highValue = Math.max(min, max);
				}
				else c.value = randInt(c.minimum, c.maximum);
			}
			else
			{
				if (c is RotarySelector) return;
				if (c is HRangeSlider || c is VRangeSlider)
				{
					min = randFloat(c.minimum, c.maximum);
					max = randFloat(c.minimum, c.maximum);
					c.lowValue = Math.min(min, max);
					c.highValue = Math.max(min, max);
				}
				else c.value = randFloat(c.minimum, c.maximum);
			}
		}
	}
}




