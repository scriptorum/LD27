package game.component;

class Control
{
	public function new()
	{
	}
}

class NarrativeControl extends Control // Can fire barrel
{
	public var page:Int = 0;

	override public function new()
	{
		super();
	}
}

class ProfileControl extends Control // Can display profile stats
{
	public static var instance:Control = new ProfileControl();
}

class MenuControl extends Control // Can click new/continue
{
	public static var instance:Control = new MenuControl();
}

class GameControl extends Control 
{
	public static var instance:Control = new GameControl();
}

class EndControl extends Control // Can click continue/replay
{
	public static var instance:Control = new EndControl();
}
