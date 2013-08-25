/*
	- Chart out your rules!! You need this done in a few hours so you can start adding effects
	  and polishing.

	- A rule should not trigger on a space that is being interacted with by a time child.

	- Revamp the trigger system to fold clicks into triggers, and rename triggers rules.
	  So for example:
	  	<rule click chance="0.5" result="fish"/>
	  	<rule click result="algae"/>
	  Here the rule is only evaluated if an interaction occurred on a matching space. There's a
	  50% chance of making a fish, otherwise it makes algae. Want the growth to happen spontaneously?
	  Simply omit the click. 

	  The problem with the above approach is there could be a delay to the processing, but since there's
	  a delay while the time child works, we should be able to save the outcome of the result during that
	  time. Perhaps we separately process automatic versus manual triggers. ResolveTriggers then should
	  be passed the trigger to resolve.

	  Right now the current click system doesn't even support multiple click handlers let alone chance.
	  ANOTHER possibility is to creative interim types that have no graphics. So perhaps when you click 
	  on an a cell it creates a cellTransition, which is assigned a type and value in MapService although 
	  it has no image. Then add cellTransition triggers to handle its immediate transformation into something
	  else. That works for me...

	- DUDE - mind map your 20 or so objects and get some basic rules thrown in there for all objects.
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
		// trace("TRACES ARE ENABLED");
		#if debug
			// #if flash
			// 	if (flash.system.Capabilities.isDebugger)
			// #end
			// HXP.console.enable();
			// HXP.console.enable(TraceCapture.No)
			// haxe.Log.trace = function(v:Dynamic, ?inf:haxe.PosInfos) {};
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