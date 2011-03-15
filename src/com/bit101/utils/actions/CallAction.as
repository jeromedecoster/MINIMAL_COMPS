
package com.bit101.utils.actions 
{
	import com.bit101.components.Component;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.DisplayObjectContainer;

	public class CallAction extends AbstractAction
	{
		public function CallAction(comp:Component,
								   args:Array,
								   configurator:MinimalConfigurator,
								   parent:DisplayObjectContainer)
		{
			super(comp, args, configurator, parent);
			
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
			
			var a:Array = [];
			var resVal:Object;
			for (var i:int = 1; i < args.length; i++)
			{
				resVal = resolveValue(resTar, args[i].slice());
				
				if (resVal == null) return;
				
				a.push(resVal.value);
			}
			
			try
			{
				Object(resTar.target[resTar.property]).apply(null, a);
			}
			catch(err:Error) {};
		}
	}
}




