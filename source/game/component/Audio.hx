package game.component;

import flash.media.SoundChannel;
import game.component.Timestamp;

// Low level "SoundChannel" wrapper
// Stored separately from Sound
// Does for Sound what Display does for View
class Audio
{
	public var channel:SoundChannel;

	// These values will be modified by the AudioSystem
	public var volume:Float; 
	public var pan:Float;
	public var startTime:Int;

	public function new(channel:SoundChannel, volume:Float = -1, pan:Float = -1)
	{
		this.channel = channel;
		this.volume = volume;
		this.pan = pan;
		startTime = Timestamp.now();
	}
}
