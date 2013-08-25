package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import game.service.EntityService;
import game.component.Timestamp;
import game.component.Text;
import game.component.Position;
import game.component.Control;

class TimerNode extends Node<TimerNode>
{
	public var timestamp:Timestamp;
	public var text:Text;
	public var position:Position;
}

class TimerUpdatingSystem extends System
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
		if(!factory.hasControl(GameControl))
			return;

		for(node in engine.getNodeList(TimerNode))
		{
			var duration = Timestamp.now() - node.timestamp.value;
			node.text.message = Std.string(duration / 1000);
		}
	}
}