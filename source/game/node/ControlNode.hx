package game.node;

import ash.core.Node;

import game.component.Control;

class NarrativeControlNode extends Node<NarrativeControlNode>
{
	public var control:NarrativeControl;
}

class MenuControlNode extends Node<MenuControlNode>
{
	public var control:MenuControl;
}

class EndControlNode extends Node<EndControlNode>
{
	public var control:EndControl;
}

class ProfileControlNode extends Node<ProfileControlNode>
{
	public var control:ProfileControl;
}

class GameControlNode extends Node<GameControlNode>
{
	public var control:GameControl;
}