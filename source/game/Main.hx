/*

 - Clicking on steam space will send it back to water but the trigger then doesn't bring it back to steam.
 - Clicking on a water space causes the space to lock up with a "null" and reclick for "time passes"
   and again will crash game "unknown object type 5". -- fixed the crash, but still.
   MAYBE this comes from "overclicking?" Clicking too much leads to strange features...

*/
package game;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import game.world.GameWorld;

class Main extends Engine
{
	public function new()
	{
		super(0,0);
	}

	override public function init()
	{
		#if debug
			#if flash
				if (flash.system.Capabilities.isDebugger)
			#end
			// HXP.console.enable();
		#end
 
		HXP.scene = new GameWorld();
	}

    override private function resize()
    {
        HXP.screen.scaleX = HXP.screen.scaleY = 1;
    	var width = (HXP.width <= 0 ? HXP.stage.stageWidth : HXP.width);
    	var height = (HXP.height <= 0 ? HXP.stage.stageHeight : HXP.height);
        HXP.resize(width, height);
    }	

	public static function Main()
	{
		new Main();
	}
}