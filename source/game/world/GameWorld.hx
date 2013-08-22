package game.world;

import com.haxepunk.HXP;
import com.haxepunk.World;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import game.service.InputService;
import game.service.EntityService;
import game.system.InputSystem;
import game.system.RenderingSystem;
import game.system.CameraSystem;
import game.system.TweeningSystem;
import game.system.InitSystem;
import game.system.AudioSystem;
import game.system.ActionSystem;
import game.component.Control;

#if profiler
	import game.system.ProfileSystem;
	import game.service.ProfileService;
#end

class GameWorld extends World
{
	private var ash:Engine;
	private var nextSystemPriority:Int = 0;
	private var factory:EntityService;

	public function new()
	{
		super();
	}

	override public function begin()
	{
		ash = new Engine(); // ecs
		factory = new EntityService(ash); // factory service
		initSystems(); // ash systems
	}

	private function initSystems()
	{
		addSystem(new InitSystem(ash, factory));
		addSystem(new InputSystem(ash, factory)); // Collect player/inventory input
		addSystem(new ActionSystem(ash, factory));
		addSystem(new TweeningSystem(ash, factory));
		addSystem(new CameraSystem(ash));
		addSystem(new RenderingSystem(ash)); // Display entities are created/destroyed/updated
		addSystem(new AudioSystem(ash));
	}	

    public function addSystem(system:System):Void
    {
    	#if profiler
    		var name = Type.getClassName(Type.getClass(system));
    		ash.addSystem(new ProfileSystem(name, true), nextSystemPriority++);
    	#end

        ash.addSystem(system, nextSystemPriority++);

    	#if profiler
    		ash.addSystem(new ProfileSystem(name, false), nextSystemPriority++);
    	#end
    }

	override public function update()
	{
		ash.update(HXP.elapsed); // Update Ash (entity system)
		super.update(); // Update HaxePunk (game library)
	}
}