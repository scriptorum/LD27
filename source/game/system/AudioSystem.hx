package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import game.component.Audio;
import game.component.Sound;
import game.component.Timestamp;
import game.node.SoundNode;
import game.service.EntityService;

import openfl.Assets;
import flash.media.SoundChannel;
import flash.events.Event;

class AudioNode extends Node<AudioNode>
{
	public var sound:Sound;
	public var audio:Audio;
}

class AudioSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
		engine.getNodeList(AudioNode).nodeRemoved.add(audioNodeRemoved);
	}

	private function audioNodeRemoved(node:AudioNode): Void
	{
		node.audio.channel.stop();
	}

	override public function update(_)
	{
		var halt = engine.getEntityByName(EntityService.AUDIO_HALT);
		if(halt != null)
		{
			var cutoff:Int = halt.get(Timestamp).stamp;
			engine.removeEntity(halt);

			for(node in engine.getNodeList(AudioNode))
			{
				if(node.audio.startTime < cutoff)
					node.sound.stop = true;
			}
		}

		for(node in engine.getNodeList(SoundNode))
		{
			var sound = node.sound;
			if(node.entity.has(Audio))
				updateAudio(sound, node.entity);
			else createAudio(sound, node.entity);
		}
	}	

	private function createAudio(sound:Sound, entity:Entity): Void
	{
		// trace("Playing sound " + sound.file + " stop:" + sound.stop);
		var nmeSound = Assets.getSound((sound.isMusic ? "music/" : "sound/") + sound.file);
		if(nmeSound == null)
		{
			#if debug
				trace("Cannot play " + sound.file);
			#end
			return;
		}

		var channel = nmeSound.play(sound.offset, (sound.loop ? 0x3FFFFFFF : 0));
		if(channel == null)
			trace("No channel returned for " + sound.file);

		if(sound.destroyEntity || sound.destroyComponent)
			channel.addEventListener (Event.SOUND_COMPLETE, function(_) {
				sound.stop = true;
			});			

		var audio = new Audio(channel, sound.volume, sound.pan);
		entity.add(audio);
	}

	private function updateAudio(sound:Sound, entity:Entity): Void
	{
		var audio = entity.get(Audio);

		if(sound.stop)
		{
			audio.channel.stop();

			if(sound.destroyEntity)	
				engine.removeEntity(entity);
			else if(sound.destroyComponent)
				entity.remove(Audio);	
			else sound.stop = false;

			return;
		}

		if(sound.restart)
		{
			sound.restart = false;
			audio.channel.stop();
			entity.remove(Audio);
			createAudio(sound, entity);
			return;
		}

		if(audio == null)
			return;

		if(sound.volume != audio.volume)
		{
			audio.volume = sound.volume;
			audio.channel.soundTransform.volume = sound.volume;
		}

		if(sound.pan != audio.pan)
		{
			audio.pan = sound.pan;
			audio.channel.soundTransform.pan = sound.pan;
		}
	}
}