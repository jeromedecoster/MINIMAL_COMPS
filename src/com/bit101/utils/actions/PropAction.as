
package com.bit101.utils.actions 
{
	import com.bit101.components.Component;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.DisplayObjectContainer;

	public class PropAction extends AbstractAction
	{
		public function PropAction(comp:Component,
								   args:Array,
								   configurator:MinimalConfigurator,
								   parent:DisplayObjectContainer)
		{
			super(comp, args, configurator, parent);
			
			// case parser == property
			if (args.length == 1)
			{
				var props:Array = getProperties(comp);
				if (props == null || props.length != 1)
				{
					return;
				}
				
				args.push("{" + comp.name + "." + props[0] + "}");
			}
			
			var exp:Boolean = explode();
			if (!exp)
			{
				return;
			}
			
			comp.addEventListener(eventName, onEvent);
			_valid = true;
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		override public function execute():void
		{
			var resTar:Object = resolveTarget(args[0].slice());
			
			if (resTar == null) return;
			
			var resVal:Object = resolveValue(resTar, args[1].slice());
			
			if (resVal == null) return;
			
			try
			{
				resTar.target[resTar.property] = resVal.value;
			}
			catch(err:Error) {};
		}
	}
}




