package game.component;

import ash.core.Engine;
import game.util.Easing;

class Tween
{
	public static var created:Int = 0;

	public var complete:Bool = false;
	public var running:Bool = false;
	public var source:Dynamic;
	public var target:Dynamic;
	public var ranges:Array<Float>;
	public var starts:Array<Float>;
	public var props:Array<String>;
	public var easing:EasingFunction;
	public var optional:Float = 1.70158;
	public var elapsed:Float = 0;
	public var duration:Float;
	public var destroyEntity:Bool = false;
	public var destroyComponent:Bool = false;
	public var fields:Array<String>;
	public var name:String; // optional object name for logging

	public function new(source:Dynamic, target:Dynamic, duration:Float, 
		easing:EasingFunction = null, autoStart:Bool = true)
	{
		this.source = source;
		this.easing = easing;
		this.duration = duration;
		this.target = target;
		this.easing = (easing == null ? Easing.linear : easing);
		
		if(autoStart)
			start();
	}

	// If not autostarted, must call this to run tween
	public function start()
	{
		this.running = true;
		this.name = "tween"  + Std.string(++created);

		if(Reflect.isObject(target))
			fields = Reflect.fields(target);
		else throw("Unsupported properties object");
		if(fields.length == 0)
			throw("No fields found for tween target; ensure it is an anonymous object.");

		ranges = new Array<Float>();
		starts = new Array<Float>();
		props = new Array<String>();
		for(field in fields)
		{
			var sVal:Float = Reflect.getProperty(source, field);
			var tVal:Float = Reflect.getProperty(target, field);
			if(Math.isNaN(tVal))
				throw("Property " + field + " is not a number");
			if(Math.isNaN(sVal))
				throw("Start object lacks numeric field " + field);
			props.push(field);
			starts.push(sVal);
			ranges.push(tVal - sVal);
			// trace("Storing field " + field + " from " + sVal + " to " + tVal  + " (" + (tVal - sVal) + ")");
		}
	}

	public function update(time:Float): Void
	{
 		if(complete || !running)
 			return;

 		elapsed = Math.min(elapsed + time, duration);
 		
		for(i in 0...props.length)
		{
			var value = easing(elapsed, starts[i], ranges[i], duration, optional);
			Reflect.setProperty(source, props[i], value);
			// trace("TWEEN Setting prop " + props[i] + " to value " + Reflect.getProperty(source, props[i]) + 
			// 	" start:" + starts[i] + " range:" + ranges[i] + " elapsed:" + elapsed);
		}

 		if(elapsed >= duration)
 			complete = true;	 			
	}	
}
