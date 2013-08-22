package game.node;

import ash.core.Node;

import game.component.CameraFocus;
import game.component.Position;

class CameraFocusNode extends Node<CameraFocusNode>
{
	public var position:Position;
	public var cameraFocus:CameraFocus;
}