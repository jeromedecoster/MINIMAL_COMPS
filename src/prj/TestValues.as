
package prj
{
	import com.bit101.components.Component;
	import com.bit101.components.Text;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.Sprite;

	public class TestValues extends Sprite 
	{
		private var configurator:MinimalConfigurator;
		
		public function TestValues()
		{
			Component.initStage(stage);
			
			var xml:XML = 	<comps>
								<VBox id="vbox" x="20" y="20" spacing="20">
									<HUISlider id="hus1" action="property(tx1.text)" maximum="157"/>
									<HSlider id="hs1" action="property(tx1.text)" maximum="157"/>
									<HRangeSlider id="hrs1" action="call(this.range,{hrs1.lowValue},{hrs1.highValue})" lowValue="160" highValue="190" maximum="201" minimum="-150"/>
									<Knob id="kn1" action="property(tx1.text)" maximum="207"/>
									<HBox spacing="20">
										<VUISlider id="vus1" action="property(tx1.text)" maximum="157"/>
										<VSlider id="vs1" action="property(tx1.text)" maximum="157"/>
										<VRangeSlider id="vrs1" action="call(this.range,{vrs1.lowValue},{vrs1.highValue})" lowValue="160" highValue="190" maximum="201" minimum="-150"/>
									</HBox>
									<HBox>
										<Text id="tx1" text="values must be rounded at 10 decimals places"/>
									</HBox>
								</VBox>
							</comps>;
			
			var def:XML = <comps>
							<HUISlider width="450" 		labelPrecision="3" tick=".001" label="huislider"/>
							<HSlider width="450" 		labelPrecision="3" tick=".001" label="hslider"/>
							<HRangeSlider width="450" 	labelPrecision="3" tick=".001"/>
							<Knob 						labelPrecision="3" label="knob"/>
							<VUISlider height="250" 	labelPrecision="3" tick=".001" label="vuislider"/>
							<VSlider height="250" 		labelPrecision="3" tick=".001" label="vslider"/>
							<VRangeSlider height="250" 	labelPrecision="3" tick=".001"/>
						</comps>;
										
			configurator = new MinimalConfigurator(this, def);
			configurator.parseXML(xml);
		}
		
		public function range(lowValue:Number, highValue:Number):void
		{
			var t:Text = configurator.getCompById("tx1") as Text;
			t.text = lowValue + "\r" + highValue;
		}
	}
}




