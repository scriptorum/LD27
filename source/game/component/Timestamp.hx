package game.component;

class Timestamp
{
	public var value:Int;

	function new(value:Int)
	{
		this.value = value;	
	}

	public static function now(): Int
	{
		return flash.Lib.getTimer();
	}

	public static function create(): Timestamp
	{
		return new Timestamp(now());
	}
}