
package prj
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HRangeSlider;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Knob;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.VBox;
	import com.bit101.components.VRangeSlider;
	import com.bit101.components.VSlider;
	import com.bit101.components.VUISlider;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class TestVBox extends Sprite
	{
		private var vbox1:VBox;
		private var cbox1:CheckBox;
		private var cbox2:CheckBox;
		private var hslid1:HSlider;
		private var hslid2:HSlider;
		private var huislid1:HUISlider;
		private var huislid2:HUISlider;
		private var inp1:InputText;
		private var inp2:InputText;
		private var nstep1:NumericStepper;
		private var nstep2:NumericStepper;
		private var pusbut1:PushButton;
		private var pusbut2:PushButton;
		private var radbut1:RadioButton;
		private var radbut2:RadioButton;
		
		private var vbox2:VBox;
		private var knob1:Knob;
		private var knob2:Knob;
		private var hransli1:HRangeSlider;
		private var hransli2:HRangeSlider;
		private var rotsel1:RotarySelector;
		private var rotsel2:RotarySelector;
		
		private var vbox3:VBox;
		private var vransli1:VRangeSlider;
		private var vransli2:VRangeSlider;
		private var vsli1:VSlider;
		private var vsli2:VSlider;
		
		private var vbox4:VBox;
		private var vuisli1:VUISlider;
		private var vuisli2:VUISlider;
		
		public function TestVBox()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			vbox1 = new VBox(this, 20, 20);
			cbox1 = new CheckBox(vbox1, 0, 0, "CheckBox");
			cbox2 = new CheckBox(vbox1, 0, 0, "CheckBox");
			hslid1 = new HSlider(vbox1, 0, 0);
			hslid2 = new HSlider(vbox1, 0, 0);
			huislid1 = new HUISlider(vbox1, 0, 0, "HUISlider");
			huislid2 = new HUISlider(vbox1, 0, 0, "HUISlider");
			inp1 = new InputText(vbox1, 0, 0, "InputText");
			inp2 = new InputText(vbox1, 0, 0, "InputText");
			nstep1 = new NumericStepper(vbox1, 0, 0);
			nstep2 = new NumericStepper(vbox1, 0, 0);
			pusbut1 = new PushButton(vbox1, 0, 0, "PushButton");
			pusbut2 = new PushButton(vbox1, 0, 0, "PushButton");
			radbut1 = new RadioButton(vbox1, 0, 0, "RadioButton");
			radbut2 = new RadioButton(vbox1, 0, 0, "RadioButton");
			
			vbox2 = new VBox(this, 250, 20);
			knob1 = new Knob(vbox2, 0, 0);
			knob2 = new Knob(vbox2, 0, 0);
			hransli1 = new HRangeSlider(vbox2, 0, 0);
			hransli2 = new HRangeSlider(vbox2, 0, 0);
			rotsel1 = new RotarySelector(vbox2, 0, 0, "RotarySelector");
			rotsel2 = new RotarySelector(vbox2, 0, 0, "RotarySelector");
			
			vbox3 = new VBox(this, 470, 20);
			vransli1 = new VRangeSlider(vbox3, 0, 0);
			vransli2 = new VRangeSlider(vbox3, 0, 0);
			vsli1 = new VSlider(vbox3, 0, 0);
			vsli2 = new VSlider(vbox3, 0, 0);
			
			vbox4 = new VBox(this, 550, 20);
			vuisli1 = new VUISlider(vbox4, 0, 0, "VUISlider");
			vuisli2 = new VUISlider(vbox4, 0, 0, "VUISlider");
		}
	}
}




