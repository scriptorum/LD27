package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import game.service.EntityService;
import game.service.InputService;
import game.service.MapService;
import game.node.ControlNode;
import game.component.Application;
import game.component.Grid;

class TriggerSystem extends System
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
	}
}