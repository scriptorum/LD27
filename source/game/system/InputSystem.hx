package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import com.haxepunk.utils.Key;

import game.service.EntityService;
import game.service.InputService;
import game.node.ControlNode;

#if profiler
	import game.service.ProfileService;
#end

#if (development && !flash)
import sys.io.FileOutput;
#end

class InputSystem extends System
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
		InputService.init();
	}

	override public function update(_)
	{
		handleProfileControl();
		handleNarrativeControl();
		InputService.clearLastKey();
	}

	public function handleProfileControl()
	{
		#if profiler 
	 	for(node in engine.getNodeList(ProfileControlNode))
	 	{
	 		if(InputService.lastKey() == Key.P)
	 		{
	 			ProfileService.dump();
	 			ProfileService.reset();
	 			InputService.clearLastKey();
	 		}
	 	}
		#end
	}

	public function handleNarrativeControl()
	{
		for(node in engine.getNodeList(NarrativeControlNode))
		{
			if(InputService.clicked)
				factory.nextNarrativePage();
		}
	}
}