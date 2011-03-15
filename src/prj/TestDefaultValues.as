
package prj
{
	import com.bit101.components.Component;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.Sprite;
	import flash.events.Event;

	public class TestDefaultValues extends Sprite 
	{
		private var configurator:MinimalConfigurator;
		
		public function TestDefaultValues()
		{
			Component.initStage(stage);
			
			var xml:XML = 	<comps>
								<VBox id="vbox" x="20" y="20">
									<HUISlider id="hs1"/>
									<HUISlider id="hs2" ref="long"/>
									<HUISlider id="hs3" ref="medium" value="-25"/>
									<HBox>
										<InputText id="it1" text="txt 1"/>
										<InputText id="it2" text="txt 2"/>
									</HBox>
									<PushButton id="pb1" label="push 1"/>
									<PushButton id="pb2" label="push 2"/>
								</VBox>
							</comps>;
							
			var def:XML = <comps>
							<InputText width="170"  event="change:onTextChange"/>
							<HUISlider width="250" event="change:onHUISliderChange"/>
							<HUISlider id="long"   minimum="-100" maximum="200" width="500" event="change:onHUISliderChange"/>
							<HUISlider id="medium" minimum="-50"  maximum="100" width="300" event="change:onHUISliderChange"/>
							<PushButton event="click:onPushButton"/>
						</comps>;
			
			configurator = new MinimalConfigurator(this, def);
			configurator.parseXML(xml);
		}
		
		public function onHUISliderChange(event:Event):void
		{
			var hui:HUISlider = event.target as HUISlider;
			trace("HUISlider name:", hui.name, "value:", hui.value);
		}
		
		public function onTextChange(event:Event):void
		{
			var inp:InputText = event.target as InputText;
			trace("InputText name:", inp.name, "value:", inp.text);
		}
		
		public function onPushButton(event:Event):void
		{
			var pb:PushButton = event.target as PushButton;
			trace("PushButton name:", pb.name, "label:", pb.label);
		}
	}
}




