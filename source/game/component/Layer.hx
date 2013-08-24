package game.component;

class Layer
{
	public static var BACK:Int = 300;
	public static var MIDDLE:Int = 200;
	public static var FRONT:Int = 100;
	public static var back:Layer = new Layer(BACK);
	public static var middle:Layer = new Layer(MIDDLE);
	public static var front:Layer = new Layer(FRONT);

	public var layer:Int;

	public function new(layer:Int)
	{
		this.layer = layer;
	}
}