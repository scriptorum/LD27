package game.component;

import game.component.TextSource;

class Firework implements TextSourceProvider
{
	public var amount:Float = 0;
	public function new(amount:Float)
	{
		this.amount = amount;
	}

	public function getFloat(): Float
	{
		return amount;
	}
}

class FireworkEffect
{
	public static var instance:FireworkEffect = new FireworkEffect();
	public function new() {}
}