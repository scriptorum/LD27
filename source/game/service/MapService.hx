package game.service;

import game.component.Grid;
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

	public static function loadRules(): Xml
	{
		var str:String = Assets.getText("xml/rules.xml");
		xml = Xml.parse(str).firstElement();

		clickMessages = new Map();
		clickResults = new Map();
		for(obj in xml.elementsNamed("object"))
		{
			var type = obj.get("type");
			for(clk in obj.elementsNamed("click"))
			{
				clickMessages.set(type, clk.get("message"));
				clickResults.set(type, clk.get("result"));
			}
		}

		return xml;
	}

	// public static function getTriggers(): Array<Trigger>
	// {

	// }

	public static function getClickResult(type:String): String
	{
		return clickResults.get(type);
	}

	public static function getClickMessage(type:String): String
	{
		return clickMessages.get(type);
	}
}