package game.node;

import ash.core.Node;

import game.component.TimeChild;
import game.component.Position;

class TimeChildNode extends Node<TimeChildNode>
{
	public var child:TimeChild;
	public var position:Position;
}