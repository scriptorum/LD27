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
import game.util.Util;

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
		handleDebugControl();
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
			{
				var x = InputService.mouseX;
				var y = InputService.mouseY;

				if(x >= 296 && x <= 311 && y >= 564 && y < 584) 
					factory.setMenuRadial(1);
				else if(x >= 330 && x <= 345 && y >= 564 && y < 584) 
					factory.setMenuRadial(2);
				else if(x >= 364 && x <= 379 && y >= 564 && y < 584) 
					factory.setMenuRadial(5);
				else if(x >= 404 && x <= 419 && y >= 564 && y < 584) 
					factory.setMenuRadial(10);
				else if(x >= 196 && x <= 376 && y >= 370 && y <= 428) 
					factory.getApplication().changeMode(ApplicationMode.NARRATIVE);
			}
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
			var index = factory.gridTest(factory.getGridEntity(), 
				InputService.mouseX, InputService.mouseY);				
			if(InputService.clicked)
			{
				if(index >= 0)
					addInteraction(index);
			}
			else if(index >= 0)
			{
				var status:String = "";
				var grid:Grid = factory.getGrid();
				var status = MapService.getTypeFromValue(grid.getIndex(index));
				if(status == "clear")
				{
					grid = factory.getTerrainGrid();
					status = MapService.getTypeFromValue(grid.getIndex(index));
				}

				factory.setStatus(status);
			}
			else factory.setStatus("");
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
				factory.setMessage("Patience");
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

	public function handleDebugControl()
	{
		// #if debug
		if(InputService.pressed(InputService.debug))
		{
			// #if !flash
			// 	var path:String = "/tmp/entities.log";
			// 	Util.dumpLog(engine, path);
			// 	// trace(Util.dumpHaxePunk(com.haxepunk.HXP.scene));
			// #end

			// factory.stopGame();					

			var grid = factory.getGrid();
			grid.set(0, 0, MapService.getValueFromType("victory"));
			grid.changed = true;
		}
		// #end
	}
}