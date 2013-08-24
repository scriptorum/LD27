package game.service;

import game.component.Grid;
import game.component.TriggerRule;
import openfl.Assets;

class MapService
{
	public static var WATER:Int = 0;
	public static var LAND:Int = 1;
	public static var LAVA:Int = 2;
	public static var STEAM:Int = 3;

	public static var CELLS:Int = 8;
	public static var ALGAE:Int = 9;
	public static var UNKNOWN:Int = 10;

	public static var WIDTH:Int = 14;
	public static var HEIGHT:Int = 13;

	public static var xml:Xml;
	public static var clickMessages:Map<String, String>;
	public static var clickResults:Map<String, String>;
	public static var triggers:Array<TriggerRule>;

	public static var typeValues:Array<String> = [
		"water", "land", "lava", "steam", null, null, null, null,
		"cells", "algae", "unknown", null, null, null, null, null
	];

	public static function getTypeFromValue(value:Int): String
	{
		var res:String = typeValues[value];
		if(res == null)
			return "unknown";
		return res;
	}

	public static function makeTerrain(): Grid
	{
		var chanceWater = 0.6;
		var grid = new Grid(WIDTH, HEIGHT);

		// Randomly set up some land/water
		for(x in 0...grid.width)
		for(y in 0...grid.height)
		{
			var value = (Math.random() <= chanceWater ? WATER : LAND);
			grid.set(x, y, value);
		}

		// Smooth out the shapes, eliminating islands and diagonals.
		var grid2 = new Grid(WIDTH, HEIGHT);

		for(x in 0...grid.width)
		for(y in 0...grid.height)
		{
			var matches = 0;
			var value = grid.get(x, y);
			var neighbors = grid.getNeighboringIndeces(grid.indexOf(x,y), true);
			for(neighbor in neighbors)
				if(grid.getIndex(neighbor) == value)
					matches++;

			if(matches == 0)
				value = grid.getIndex(neighbors[0]);

			grid2.set(x, y, value);
		}

		return grid2;
	}

	public static function makeObjects(): Grid
	{
		var grid = new Grid(WIDTH, HEIGHT, LAVA);

		// for(x in 0...grid.width)
		// for(y in 0...grid.height)
		// {
		// 	var value = UNKNOWN;
		// 	grid.set(x, y, value);
		// }

		return grid;
	}

	public static function init(): Xml
	{
		var str:String = Assets.getText("xml/rules.xml");
		xml = Xml.parse(str).firstElement();

		clickMessages = new Map();
		clickResults = new Map();
		triggers = new Array<TriggerRule>();

		for(obj in xml.elementsNamed("object"))
		{
			// Load click rules
			var type:String = obj.get("type");
			for(clk in obj.elementsNamed("click"))
			{
				clickMessages.set(type, clk.get("message"));
				clickResults.set(type, clk.get("result"));
				// NOTE this will break if you assign multiple clicks to a single object
				// You'll need to refactor this if you want to add conditional clicks
			}

			// Load trigger rules
			for(trg in obj.elementsNamed("trigger"))
			{
				var trigger = new TriggerRule(type, trg.get("terrain"), trg.get("result"), 
					trg.get("message"), trg.get("neighbor"));
				if(trg.exists("chance"))
					trigger.chance = Std.parseFloat(trg.get("chance"));
				if(trg.exists("max"))
					trigger.min = Std.parseInt(trg.get("max"));
				if(trg.exists("min"))
					trigger.min = Std.parseInt(trg.get("min"));
				triggers.push(trigger);
			}
		}

		return xml;
	}

	public static function getTriggerRules(): Array<TriggerRule>
	{
		return triggers;
	}

	public static function getClickResult(type:String): String
	{
		return clickResults.get(type);
	}

	public static function getClickMessage(type:String): String
	{
		return clickMessages.get(type);
	}
}