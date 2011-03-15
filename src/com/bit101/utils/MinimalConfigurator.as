/**
 * MinimalConfigurator.as
 * Keith Peters
 * version 0.9.9
 * 
 * A class for parsing xml layout code to create minimal components declaratively.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.utils
{
	import com.bit101.components.Accordion;
	import com.bit101.components.Calendar;
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.FPSMeter;
	import com.bit101.components.HBox;
	import com.bit101.components.HRangeSlider;
	import com.bit101.components.HScrollBar;
	import com.bit101.components.HSlider;
	import com.bit101.components.HUISlider;
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.InputText;
	import com.bit101.components.Knob;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.ListItem;
	import com.bit101.components.Meter;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.Panel;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.RangeSlider;
	import com.bit101.components.RotarySelector;
	import com.bit101.components.ScrollBar;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.Slider;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import com.bit101.components.UISlider;
	import com.bit101.components.VBox;
	import com.bit101.components.VRangeSlider;
	import com.bit101.components.VScrollBar;
	import com.bit101.components.VSlider;
	import com.bit101.components.VUISlider;
	import com.bit101.components.WheelMenu;
	import com.bit101.components.Window;
	import com.bit101.utils.actions.CallAction;
	import com.bit101.utils.actions.IAction;
	import com.bit101.utils.actions.PropAction;
	import com.bit101.utils.actions.RandAction;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	/**
	 * Creates and lays out minimal components based on a simple xml format.
	 */
	public class MinimalConfigurator extends EventDispatcher
	{
		protected var loader:URLLoader;
		protected var parent:DisplayObjectContainer;
		protected var idMap:Object;
		protected var post:Object;
		protected var defaultValues:XML;
		
		/**
		 * Constructor.
		 * @param parent The display object container on which to create components and look for ids and event handlers.
		 */
		public function MinimalConfigurator(parent:DisplayObjectContainer, defaultValues:XML = null)
		{
			this.parent = parent;
			this.defaultValues = defaultValues;
			idMap = new Object();
			
			post = new Object();
			post["RotarySelector"] 	= ["choice"];
			post["Knob"] 			= ["value"];
			post["Meter"] 			= ["value"];
			post["NumericStepper"] 	= ["value"];
			post["Slider"] 			= ["value"];
			post["HSlider"]			= ["value"];
			post["HUISlider"] 		= ["value"];
			post["VSlider"] 		= ["value"];
			post["VUISlider"] 		= ["value"];
			post["HRangeSlider"]	= ["lowValue", "highValue"];
			post["VRangeSlider"]	= ["lowValue", "highValue"];
		}
		
		//--------------------------------------
		//  EVENTS
		//--------------------------------------
		
		/**
		 * Called when the xml has loaded. Will attempt to parse the loaded data as xml.
		 */
		private function onLoadComplete(event:Event):void
		{
			parseXMLString(loader.data as String);
		}
		
		//--------------------------------------
		//  PRIVATE
		//--------------------------------------
		
		/**
		 * Parses a single component's xml.
		 * @param xml The xml definition for this component.
		 * @return A component instance.
		 */
		private function parseComp(xml:XML):Component
		{
			var compInst:Object;
			try
			{
				var name:String = xml.name();
				
				if (defaultValues != null)
				{
					injectValues(xml, name);
				}
				
				var classRef:Class = getDefinitionByName("com.bit101.components." + name) as Class;
				compInst = new classRef();
				
				// id is special case, maps to name as well.
				var id:String = trim(xml.@id.toString()); 
				if (id != "")
				{
					compInst.name = id;
					idMap[id] = compInst;
					
					// if id exists on parent as a public property, assign this component to it.
					if (parent.hasOwnProperty(id))
					{
						parent[id] = compInst;
					}
				}
				
				// event is another special case
				if (xml.@event.toString() != "")
				{
					// events are in the format: event="eventName:eventHandler"
					// i.e. event="click:onClick"
					var parts:Array = xml.@event.split(":");
					var eventName:String = trim(parts[0]);
					var handler:String = trim(parts[1]);
					if (parent.hasOwnProperty(handler))
					{
						// if event handler exists on parent as a public method, assign it as a handler for the event.
						compInst.addEventListener(eventName, parent[handler]);
					}
				}
				
				var tmp:Object = {};
				
				// every other attribute handled essentially the same
				for each (var attrib:XML in xml.attributes())
				{
					var prop:String = attrib.name().toString();
					// if the property exists on the component, assign it.
					if (compInst.hasOwnProperty(prop))
					{
						if (post[name] != null && post[name].indexOf(prop) > -1)
						{
							// set this prop later
							tmp[prop] = attrib;
							continue;
						}
						
						// special handling to correctly parse booleans
						if (compInst[prop] is Boolean)
						{
							compInst[prop] = attrib == "true";
						}
						else
						{
							compInst[prop] = attrib;
						}
					}
				}
				
				// at the end, assign special props
				for (var s:String in tmp)
				{
					compInst[s] = tmp[s];
				}
				
				// child nodes will be added as children to the instance just created.
				for (var j:int = 0; j < xml.children().length(); j++)
				{
					var child:Component = parseComp(xml.children()[j]);
					if (child != null)
					{
						compInst.addChild(child);
					}
				}
			}
			catch(e:Error) {}
			
			return compInst as Component;
		}
		
		/**
		 * Split a string of elements separated with ,
		 * trim every returned element
		 */
		private function split(str:String):Array
		{
			var a:Array = [];
			var s:String;
			var tmp:Array = str.split(",");
			for (var j:int; j < tmp.length; j++)
			{
				s = trim(tmp[j]);
				if (s != "") a.push(s);
			}
			
			return a;
		}
		
		/**
		 * Return an array of string with the matched elements
		 */
		private function exec(pattern:RegExp, str:String):Array
		{
			var a:Array = [];
			if (pattern == null || str == null) return a;
			
			pattern.lastIndex = 0;
			var o:Object = pattern.exec(str);
			while (o != null)
			{
				a.push(String(o));
				o = pattern.exec(str);
			}
			
			return a;
		}
		
		private function injectValues(xml:XML, name:String):void
		{
			// resolve an e4x bug. Search name() with a var 'name' are buggy:
			// var name:String;
			// defaultValues.*.(name() == name);
			// var s:String = name;
			// defaultValues.*.(name() == s);
			var s:String = name;
			var refList:XMLList = xml.attribute("ref");
			var nameList:XMLList;
			
			// has a ref
			if (refList.length() == 1)
			{
				var ref:String = refList[0].valueOf();
				delete xml.@ref;
				nameList = defaultValues.*.(name() == s &&
											attribute("id").length() > 0 &&
											attribute("id")[0] == ref);
			}
			
			// has no ref or has an unfound ref
			if (nameList == null || (nameList != null && nameList.length() == 0))
			{
				nameList = defaultValues.*.(name() == s);
			}
			
			if (nameList.length() > 0)
			{
				for each (var x:XML in nameList[0].attributes())
				{
					var att:String = x.name().toString();
					if (att == "id") continue;
					if (xml.attribute(att).length() == 0)
					{
						xml.@[att] = x.valueOf();
					}
				}
			}
		}
		
		/**
		 * Trims a string.
		 * @param s The string to trim.
		 * @return The trimmed string.
		 */
		private function trim(s:String):String
		{
			// http://jeffchannell.com/ActionScript-3/as3-trim.html
			return s.replace(/^\s+|\s+$/gs, '');
		}
		
		//--------------------------------------
		//  PUBLIC
		//--------------------------------------
		
		/**
		 * Loads an xml file from the specified url and attempts to parse it as a layout format for this class.
		 * @param url The location of the xml file.
		 */
		public function loadXML(url:String):void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.load(new URLRequest(url));
		}
		
		/**
		 * Parses a string as xml.
		 * @param string The xml string to parse.
		 */ 
		public function parseXMLString(string:String):void
		{
			try
			{
				var xml:XML = new XML(string);
				parseXML(xml);
			}
			catch (e:Error) {}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Parses xml and creates components based on it.
		 * @param xml The xml to parse.
		 */
		public function parseXML(xml:XML):void
		{
			// root tag should contain one or more component tags
			// each tag's name should be the base name of a component, i.e. "PushButton"
			// package is assumed "com.bit101.components"
			for (var i:int = 0; i < xml.children().length(); i++)
			{
				var comp:XML = xml.children()[i];
				var compInst:Component = parseComp(comp);
				if(compInst != null)
				{
					parent.addChild(compInst);
				}
			}
			
			const EXPLOSE:RegExp = /\w+\([\w\s,@\.\{\}-]+\)/gi;
			const NAME:RegExp = /\w+(?=\()/gi;
			const IDS:RegExp = /(?<=\()[\w\s,@\.\{\}-]+/gi;
			var xlist:XMLList = xml..*.(attribute("action").length());
			
			var id:String;
			var action:String;
			var arrExp:Array;
			var arrNames:Array;
			var arrIds:Array;
			var args:Array;
			var name:String;
			var ia:IAction;
			var j:int;
			var k:int;
			var cmp:Component;
			
			for (i = 0; i < xlist.length(); i++)
			{
				id = trim(xlist[i].@id);
				if (id == "") continue;
				
				action 	= trim(xlist[i].@action);
				if (action == "") continue;
				
				arrExp = exec(EXPLOSE, action);
				for (j = 0; j < arrExp.length; j++)
				{
					arrNames = exec(NAME, arrExp[j]);
					if (arrNames.length == 0) continue;
					
					arrIds = exec(IDS, arrExp[j]);
					if (arrIds.length == 0) continue;
					
					args = split(arrIds[0]);
					if (args.length == 0) continue;
					
					cmp = getCompById(id);
						
					name = arrNames[0];
					if (name == "prop")
					{
						ia = new PropAction(cmp, args, this, parent);
					}
					else if (name == "call")
					{
						ia = new CallAction(cmp, args, this, parent);
					}
					else if (name == "property")
					{
						for (k = 0; k < args.length; k++)
						{
							ia = new PropAction(cmp, [args[k]], this, parent);
							if (!ia.valid) ia = null;
						}
					}
					else if (name == "select")
					{
						for (k = 0; k < args.length; k++)
						{
							ia = new PropAction(cmp, ["{" + args[k] + ".selected}", "{true}"], this, parent);
							if (!ia.valid) ia = null;
						}
					}
					else if (name == "deselect")
					{
						for (k = 0; k < args.length; k++)
						{
							ia = new PropAction(cmp, ["{" + args[k] + ".selected}", "{false}"], this, parent);
							if (!ia.valid) ia = null;
						}
					}
					else if (name == "clear")
					{
						for (k = 0; k < args.length; k++)
						{
							ia = new PropAction(cmp, ["{" + args[k] + ".text}", "{}"], this, parent);
							if (!ia.valid) ia = null;
						}
					}
					else if (name == "fill")
					{
						for (k = 0; k < args.length; k += 2)
						{
							if (k + 1 < args.length)
							{
								ia = new PropAction(cmp, ["{" + args[k] + ".text}", args[int(k + 1)]], this, parent);
								if (!ia.valid) ia = null;
							}
						}
					}
					else if (name == "randInt" || name == "randFloat")
					{
						for (k = 0; k < args.length; k++)
						{
							ia = new RandAction(cmp, [args[k]], this, parent, name == "randInt");
							if (!ia.valid) ia = null;
						}
					}
					
					if (ia != null && !ia.valid) ia = null;
				}
			}
		}
		
		
		
		/**
		 * Returns the componet with the given id, if it exists.
		 * @param id The id of the component you want.
		 * @return The component with that id, if it exists.
		 */
		public function getCompById(id:String):Component
		{
			return idMap[id];
		}
		
		/**
		 * We need to include all component classes in the swf.
		 */
		Accordion;
		Calendar;
		CheckBox;
		ColorChooser;
		ComboBox;
		FPSMeter;
		HBox;
		HRangeSlider;
		HScrollBar;
		HSlider;
		HUISlider;
		IndicatorLight;
		InputText;
		Knob;
		Label;
		List;
		ListItem;
		Meter;
		NumericStepper;
		Panel;
		ProgressBar;
		PushButton;
		RadioButton;
		RangeSlider;
		RotarySelector;
		ScrollBar;
		ScrollPane;
		Slider;
		Style;
		Text;
		TextArea;
		UISlider;
		VBox;
		VRangeSlider;
		VScrollBar;
		VSlider;
		VUISlider;
		WheelMenu;
		Window;
	}
}




