package game.component;

using StringTools;

// Basic sound component
class Sound
{
	public var destroyEntity:Bool = false; // on complete/stop, removes whole entity
	public var destroyComponent:Bool = false; // on complete/stop, removes Sound component from entity
	public var loop:Bool = false; // loop sound continuously
	public var restart:Bool = false; // restart sound from beginning ASAP
	public var stop:Bool = false; // stop sound ASAP
	public var file:String;
	public var isMusic:Bool;
	public var offset:Float;

	// May be modified real-time, will be picked up by AudioSystem
	public var volume:Float = 1; // 0-1
	public var pan:Float = 0; // -1 full left, +1 full right

	public function new(file:String, loop:Bool = false, offset:Float = 0)
	{
		this.isMusic = file.endsWith("mp3");
		this.file = file;
		this.loop = loop;
		this.offset = offset;
	}
}