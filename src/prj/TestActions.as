
package prj
{
	import com.bit101.components.Component;
	import com.bit101.utils.MinimalConfigurator;

	import flash.display.Sprite;

	public class TestActions extends Sprite 
	{
		private var configurator:MinimalConfigurator;
		public var square:Square;
		
		public function TestActions()
		{
			square = new Square();
			square.x = 350;
			square.y = 100;
			addChild(square);
			
			Component.initStage(stage);
			
			var xml:XML = 	<comps>
								<VBox id="vbox" x="20" y="20">
									<HUISlider id="hs1" action="property(square.rotation)"   label="rotation"/>
									<HUISlider id="hs2" action="property(square.rect.alpha)" label="alpha" minimum="0" maximum="1" tick=".1" value="1"/>
									<HUISlider id="hs3" action="property(square.rotation,square.rect.rotation)" label="2 rotations"/>
									<HBox>
										<PushButton id="pbpr" action="prop({square.rotation},{12.5})"   label="rotation 12.5"/>
									</HBox>
									<HBox>
										<InputText id="it1" action="property(it2.text)" text="change me"/>
										<InputText id="it2" text="txt 2"/>
									</HBox>
									<HBox>
										<PushButton id="pbcl" action="clear(it1,it2)"   label="clear"/>
										<PushButton id="pbfi" action="fill(it1,change it,it2,{square.rect.alpha})" label="fill"/>
									</HBox>
									<CheckBox id="cb1" label="cb1"/>
									<CheckBox id="cb2" label="cb2"/>
									<CheckBox id="cb3" label="cb3"/>
									<HBox>
										<PushButton id="pbse" action="select(cb1,cb2,cb3)"   label="select all"/>
										<PushButton id="pbde" action="deselect(cb1,cb2,cb3)" label="deselect all"/>
									</HBox>
									<VBox spacing="20">
										<HUISlider id="hs4" label="hs4"/>
										<HRangeSlider id="hrs1" lowValue="160" highValue="190" maximum="200" minimum="150"/>
										<RotarySelector id="rs1" numChoices="5"/>
									</VBox>
									<HBox>
										<PushButton id="pbri" action="randInt(hs4,hrs1,rs1)"     label="randInt"/>
										<PushButton id="pbfl" action="randFloat(hs4,hrs1,rs1)"   label="randFloat"/>
										<PushButton id="pbca" action="call(square.test,{hs4.value},cb1.selected,trace me)" label="call(square.test,{hs4.value},cb1.selected,trace me)" width="250"/>
									</HBox>
								</VBox>
							</comps>;
							
			configurator = new MinimalConfigurator(this);
			configurator.parseXML(xml);
		}
	}
}


import flash.display.Sprite;

class Square extends Sprite
{
	public var rect:Sprite;
	
	public function Square() 
	{
		graphics.beginFill(0xff, .5);
		graphics.drawRect(0, 0, 50, 50);
		graphics.endFill();

		rect = new Sprite();
		rect.graphics.beginFill(0xff0000, .3);
		rect.graphics.drawRect(0, 0, 100, 50);
		rect.graphics.endFill();
		rect.x = 10;
		rect.y = 10;
		addChild(rect);
	}
	
	public function test(rotation:Number, opaque:Boolean, write:String):void
	{
		rect.rotation = rotation;
		rect.alpha = opaque ? .7 : .2;
		trace("write:", write);
	}
}




