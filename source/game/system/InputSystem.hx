package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import com.haxepunk.utils.Key;

import game.service.EntityService;
import game.service.InputService;
import game.service.MapService;
import game.node.ControlNode;
import game.node.InteractionNode;
import game.component.Application;
import game.component.Grid;
import game.component.Interaction;

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
		handleMenuControl();
		handleGameControl();
		handleEndControl();
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

	public function handleMenuControl()
	{
		for(node in engine.getNodeList(MenuControlNode))
		{
			if(InputService.clicked)
				factory.getApplication().changeMode(ApplicationMode.NARRATIVE);
		}
	}

	public function handleNarrativeControl()
	{
		for(node in engine.getNodeList(NarrativeControlNode))
		{
			if(InputService.clicked)
				factory.nextNarrativePage();
		}
	}

	public function handleGameControl()
	{
		for(node in engine.getNodeList(GameControlNode))
		{
			if(InputService.clicked)
			{
				var index = factory.gridTest(factory.getGridEntity(), 
					InputService.mouseX, InputService.mouseY);
				if(index >= 0)
					addInteraction(index);
				else factory.getApplication().changeMode(ApplicationMode.END);
			}
		}
	}

	public function addInteraction(index:Int): Void
	{
		var grid:Grid = factory.getGrid();
		var pt = grid.fromIndex(index);

		// Ensure existing interaction does not exist
		for(node in engine.getNodeList(InteractionNode))
		{
			if(pt.x == node.interaction.x && pt.y == node.interaction.y)
			{
				factory.setMessage("Time makes you wait");
				return;
			}
		}

		var gridEnt = factory.getGridEntity();
		gridEnt.add(new Interaction(pt.x, pt.y));
	}

	public function handleEndControl()
	{
		for(node in engine.getNodeList(EndControlNode))
		{
			if(InputService.clicked)
				factory.getApplication().changeMode(ApplicationMode.MENU);
		}
	}
}