package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import game.service.EntityService;
import game.service.InputService;
import game.service.MapService;
import game.node.ControlNode;
import game.node.InteractionNode;
import game.node.TimeChildNode;
import game.component.Application;
import game.component.ActionQueue;
import game.component.Tween;
import game.component.Grid;
import game.component.TimeChild;
import game.component.Interaction;
import game.component.Position;
import game.component.Alpha;
import game.component.Origin;
import game.component.Rotation;
import game.component.Image;
import game.util.Easing;

class InteractionSystem extends System
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function update(_)
	{
		for(node in engine.getNodeList(InteractionNode))
		{
			// See if any children are working on this space already
			if(node.interaction.assigned)
				continue;

			// Find an available child
			var childEnt = findAvailableChild();			
			if(childEnt == null)
			{
				factory.setMessage("All children are busy");
				node.entity.remove(Interaction);
			}

			// Put that rascal to work
			else employChild(childEnt, node.interaction, node.position);
		}
	}

	public function employChild(childEnt:Entity, interaction:Interaction, gridPos:Position): Void
	{
			// Set child to working
			var gridEnt:Entity = factory.getGridEntity();
			var timeChild = childEnt.get(TimeChild);
			var alpha = childEnt.get(Alpha);
			var rotation = childEnt.get(Rotation);
			var position = childEnt.get(Position);
			timeChild.working = true;
			interaction.assigned = true;

			// Determine target
			var px = interaction.x * 40 + gridPos.x;
			var py = interaction.y * 40 + gridPos.y;

			// Animate child to target
			var origPos:Position = position.clone();
			var aq:ActionQueue = factory.addActionQueue();
			var tweenAlphaIn = factory.addTween(alpha, { value:0.5 }, 0.4, Easing.linear);
			var tweenPosAway = factory.addTween(position, { x:px, y:py }, 0.4, Easing.easeInOutQuad);
			aq.waitForProperty(tweenPosAway, "complete", true);

			// Swap child image for "working" image (probably use Tiles for this)
			aq.addCallback(function() {
				childEnt.add(new Image("art/child-anim.png"));
				alpha.value = 1;
			});

			// Animate working image
			// TODO Get 10 seconds from config 
			var time = 2; // hack for convenience
			var tweenRot360 = factory.addTween(rotation, { angle:360 }, time - 0.4, Easing.linear, false);
			aq.addCallback(function() { tweenRot360.start(); });
			aq.waitForProperty(tweenRot360, "complete", true);

			// Change underlying grid			
			var grid = factory.getGrid();
			var value = grid.get(interaction.x, interaction.y);
			var type = MapService.getTypeFromValue(value);
			var newType:String = MapService.getClickResult(type);
			var newValue = MapService.getValueFromType(newType);
			aq.addCallback(function() { 
				if(newValue >= 0)
					grid.set(interaction.x, interaction.y, newValue); 
				grid.changed = true;
				factory.setMessage(MapService.getClickMessage(type));
				timeChild.pleaseTrigger = true;
				gridEnt.remove(Interaction);
			});

			// Animate child back to origin
			aq.addComponent(childEnt, new Image("art/child-icon.png"));
			var tweenAlphaOut = factory.addTween(alpha, { value: 1.0 }, 0.4, Easing.linear, false);
			var tweenPosBack = factory.addTween(position, { x:origPos.x, y:origPos.y }, 0.4, Easing.easeInOutQuad, false);
			aq.addCallback(function() {
				childEnt.get(Rotation).angle = 0.0;
				tweenAlphaOut.start();
				tweenPosBack.start();
			});
			aq.waitForProperty(tweenPosBack, "complete", true);

			// Turn off working
			aq.addCallback(function() {
				timeChild.working = false;
			});		
	}

	public function findAvailableChild(): Entity
	{
		for(node in engine.getNodeList(TimeChildNode))
		{
			if(!node.child.working)
				return node.entity;
		}

		return null;
	}
}