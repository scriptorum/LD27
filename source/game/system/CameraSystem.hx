
package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.haxepunk.HXP;

import game.component.CameraFocus;
import game.component.Position;
import game.service.CameraService;
import game.node.CameraFocusNode;
import game.util.Util;

class CameraSystem extends System
{
	public var engine:Engine;
	private var targetX:Float = 0;
	private var targetY:Float = 0;
	private var i:Int = 0;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
		var x:Float = 0;
		var y:Float = 0;

	 	for(node in engine.getNodeList(CameraFocusNode))
	 	{
	 		x = node.position.x - HXP.halfWidth;
	 		y = node.position.y - HXP.halfHeight;
			// haxe.Log.clear();	 	
	 	// 	trace(++i + " - Focusing on:" + Util.roundTo(x,1) + "," + Util.roundTo(y,1) +
	 	// 		" currentTarget:" + Util.roundTo(targetX,1) + "," + Util.roundTo(targetY,1));
	 		break;	 		
	 	}

		if(Util.fdiff(x, targetX) >= 0.5 || Util.fdiff(y, targetY) >= 0.5)
		{
			targetX = x;
			targetY = y;
			CameraService.animCameraTo(targetX, targetY, 0.8);
			// trace("Moving camera from " + HXP.camera.x + "," + HXP.camera.y + " to " + x +"," + y);
		}	 	

 		// HXP.camera.x = x;
 		// HXP.camera.y = y;
	}
}