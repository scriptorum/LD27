package game.node;

import ash.core.Node;

import game.component.Interaction;
import game.component.Grid;
import game.component.Position;

class InteractionNode extends Node<InteractionNode>
{
	public var interaction:Interaction;
	public var grid:Grid;
	public var position:Position;
}

