package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import game.service.EntityService;
import game.service.InputService;
import game.service.MapService;
import game.node.ControlNode;
import game.node.TimeChildNode;
import game.component.Application;
import game.component.Grid;
import game.component.TriggerRule;

class TriggerSystem extends System
{
	public static var TRIGGER_FREQ:Float = 0.150;
	public var engine:Engine;
	public var factory:EntityService;
	public var currentTrigger:Int = -1;
	public var accumTime:Float = 0;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	// ORIGINAL THOUGHT PROCESS:
	// After any click, set flag to RESTART_TRIGGER_RESOLUTION
	// Triggering System:
	//   - If < 100ms since last trigger check, skip
	//   - If CURRENT_RESOLVE_OBJECT/TRIGGER is not null, resolve that trigger
	//     - If a trigger is activate, stop (so trigger resolves again next iteration)
	//     - If a trigger is NOT activated set TRIGGER to next one in list
	//       (Always resolve triggers from early objects first, they're highest priority.)
	//     - If at end of trigger list set CURRENT_RESOLVE_OBJECT/TRIGGER to null
	//   - Otherwise if RESTART_TRIGGER_RESOLUTION flag on, turn flag off and set 
	//     CURRENT_RESOLVE_OBJECT/TRIGGER to first object/first trigger and resolve as above.

	// After a click makes a change, that space is subject to a LOCK period, which lasts until 
	// all triggering stops. The message "Watching changes occur" shows if you click on such a space.
	override public function update(elapsed:Float)
	{
		if(MapService.triggers == null)
			return;

		if(currentTrigger < 0)
		{
			if(triggerRequested())
				currentTrigger = 0;
			else return;
		}

		// Throttle calls a bit
		else
		{
			accumTime += elapsed;
			// trace("Checking trigger throttle, trigger is:" + currentTrigger + " accumTime:" + accumTime);
			if(accumTime < TRIGGER_FREQ)
				return;
			accumTime -= TRIGGER_FREQ;		
		}

			// trace("Resolving next trigger:");
		// Resolve trigger
		// If activated, stop, so trigger resolves again next iteration
		if(resolveTrigger())
			return;

		// Set trigger to next in list or mark end of list (if trigger requested, triggering will resolve next iteration)
		if(++currentTrigger >= MapService.triggers.length)
			currentTrigger = -1;
	}

	// Return true if trigger "activates"
	public function resolveTrigger(): Bool
	{
		var rule:TriggerRule = MapService.triggers[currentTrigger];
		var grid = factory.getGrid();
		var terrainGrid = factory.getTerrainGrid();
		var triggerMatches:Int = 0;
		var changeList:Map<Int,Int> = null;

		for(i in 0...grid.size)
		{
			// Match terrain type
			if(rule.terrainType != "any")
			{
				var type = MapService.getTypeFromValue(terrainGrid.getIndex(i));
				if(type != rule.terrainType)
					continue;
			}

			// Match object type
			if(rule.type == "any" || rule.typeValue != grid.getIndex(i))
				continue;

			// Hrm -- why would this be null? What kind of trigger does not require a neighbor type?
			// TODO probably an issue here
			if(rule.neighborType == null)
				continue;

			// trace("(1) Trigger check! rule:"+ game.util.Util.dump(rule) + " at position " + i);

			// Count neighbor matches
			var neighborMatches = 0;
			for(neighbor in grid.getNeighboringIndeces(i))
				if(grid.getIndex(neighbor) == rule.neighborValue)
					neighborMatches++;

			// Match neighbor min/max matches
			if(neighborMatches < rule.min || neighborMatches > rule.max)
				continue;

			// trace("(2) Trigger check! rule:"+ game.util.Util.dump(rule) + " at position " + i);

			// If chance involved, go for it
			if(rule.chance < 1.0 && Math.random() < rule.chance)
				continue;

			// trace("(3) Trigger check! rule:"+ game.util.Util.dump(rule) + " at position " + i);

			// We have a match! Finally! Goddamn.
			triggerMatches++;
			if(changeList == null)
			 	changeList = new Map<Int, Int>();
			changeList.set(i, rule.resultValue);
			// trace("(4) Trigger check! rule:"+ game.util.Util.dump(rule) + " at position " + i);
		}

		// If no matches, this trigger didn't activate. Go home.
		if(triggerMatches <= 0)
			return false;

		trace("Found " + triggerMatches + " changes due to rule " + game.util.Util.dump(rule) + 
			" with indeces" + changeList);

		// Matches, so apply the changes to the grid
		for(change in changeList.keys())
			grid.setIndex(change, changeList[change]);
		grid.changed = true;
		factory.setMessage(rule.message);

		return true;
	}

	// See if a trigger request has been put in
	// If so clear those requests and return true
	public function triggerRequested(): Bool
	{
		var reply:Bool = false;
		for(node in engine.getNodeList(TimeChildNode))
		{
			if(node.child.pleaseTrigger)
			{
				reply = true;
				node.child.pleaseTrigger = false;
			}
		}
		// trace("Checking if triggers are requested:" + (reply ? " and they are!" : " but they're not"));
		return reply;
	}
}