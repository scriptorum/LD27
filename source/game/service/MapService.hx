package game.service;

import game.component.Grid;

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

	public static function makeTerrain(): Grid
	{
		var chanceWater = 0.65;
		var grid = new Grid(WIDTH, HEIGHT);

		for(x in 0...grid.width)
		for(y in 0...grid.height)
		{
			var value = (Math.random() <= chanceWater ? WATER : LAND);
			grid.set(x, y, value);
		}

		return grid;
	}

	public static function makeObjects(): Grid
	{
		var grid = new Grid(WIDTH, HEIGHT);

		for(x in 0...grid.width)
		for(y in 0...grid.height)
		{
			var value = UNKNOWN;
			grid.set(x, y, value);
		}

		return grid;
	}
}