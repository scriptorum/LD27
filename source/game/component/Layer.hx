package game.component;

class Layer
{
	public static var BACK:Int = 300;
	public static var MIDDLE:Int = 200;
	public static var FRONT:Int = 100;

	public var layer:Int;

	public function new(layer:Int)
	{
		this.layer = layer;
	}
}