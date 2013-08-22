package game.node;

import ash.core.Node;
import game.component.Repeating;
import game.component.Image;
import game.component.Animation;
import game.component.Position;
import game.component.Grid;
import game.component.Text;
import game.component.Tile;
import game.component.Subdivision;
import game.component.Emitter;

class ImageNode extends Node<ImageNode>
{
	public var position:Position;
	public var image:Image;
}

class AnimationNode extends Node<AnimationNode>
{
	public var position:Position;
	public var animation:Animation;
}

class BackdropNode extends Node<BackdropNode>
{
	public var image:Image;
	public var repeating:Repeating;
}

class GridNode extends Node<GridNode>
{
	public var position:Position;
	public var grid:Grid;
	public var image:Image;
	public var subdivision:Subdivision;
}

class TextNode extends Node<TextNode>
{
	public var position:Position;
	public var text:Text;
}

class EmitterNode extends Node<EmitterNode>
{
	public var position:Position;
	public var text:Emitter;
}
