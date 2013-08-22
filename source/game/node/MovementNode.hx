package game.node;

import game.component.Position;
import game.component.Velocity;
import ash.core.Node;

class MovementNode extends Node<MovementNode>
{
	public var position:Position;
	public var velocity:Velocity;
}