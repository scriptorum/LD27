package game.component;

class Interaction
{
	public var x:Int;
	public var y:Int;
	public var assigned:Bool = false;
	
	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}
}