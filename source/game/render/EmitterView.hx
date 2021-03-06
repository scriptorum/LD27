package game.render;

import com.haxepunk.HXP;
import flash.geom.Rectangle;

import game.component.Emitter;
import game.component.Rotation;
import game.component.Display;

/*
 * Particle emitter display.
 */
class EmitterView extends View
{
	private static inline var FX:String = "FX";

	private var emitter:Emitter;
	private var change:Emitter; // Tests for changes
	private var display:com.haxepunk.graphics.Emitter;

	override public function begin()
	{
		type = "emitter";
		nodeUpdate();
	}

	private function setDisplay()
	{
		var displayChanged = false;
		var emitter = getComponent(Emitter);
		if(this.emitter != emitter)
		{
			this.emitter = emitter;
			if(emitter == null)
			{
				graphic = display = null;
				change = null;
				return;
			}

			change = new Emitter(emitter.particle);
			var bm = HXP.getBitmap(emitter.particle);
			var pWidth:Int = emitter.scale == null ? bm.width : cast (bm.width * emitter.scale.x);
			var pHeight:Int = emitter.scale == null ? bm.height : cast (bm.height * emitter.scale.y);
			graphic = display = new com.haxepunk.graphics.Emitter(emitter.particle,  pWidth, pHeight);
	        display.newType(FX, [0]);
	        displayChanged = true;
		}

		var lifespanChanged:Bool = false;
		if(displayChanged || 
			!Rotation.match(emitter.rotation, change.rotation) || 
			!Rotation.match(emitter.rotation, change.rotation) || 
			emitter.distance != change.distance || 
			emitter.distanceRand != change.distanceRand || 
			emitter.lifespan != change.lifespan || 
			emitter.lifespanRand != change.lifespanRand)
		{
			var angle:Int = emitter.rotation == null ? 90 : cast (-emitter.rotation.angle) % 360;
			var angleRand:Int = emitter.rotationRand == null ? 0 : cast -emitter.rotationRand.angle;
	
			// Adjust angle values so that actual angle = angle +/- angleRand
			if(angleRand != 0)
			{
				// TODO Not sure why Neko does this differently, possibly HaxePunk 1.72a bug? Figure out later.
				#if !neko
					angle -= angleRand;
				#end
				angleRand *= 2;			
			}

	        display.setMotion(FX, angle, emitter.distance, emitter.lifespan, 
	        	angleRand, emitter.distanceRand, emitter.lifespanRand, null);

			change.rotation = Rotation.safeClone(emitter.rotation);
			change.rotationRand = Rotation.safeClone(emitter.rotationRand);
			change.distance = emitter.distance;
			change.distanceRand = emitter.distanceRand;
			change.lifespan = emitter.lifespan;
			change.lifespanRand = emitter.lifespanRand;
			lifespanChanged = true;
		}

		if(displayChanged || emitter.colorStart != change.colorStart || emitter.colorEnd != change.colorEnd)
		{
	        display.setColor(FX, emitter.colorStart, emitter.colorEnd);
	        change.colorStart = emitter.colorStart;
	        change.colorEnd = emitter.colorEnd;
		}

		if(displayChanged || emitter.alphaStart != change.alphaStart || emitter.alphaEnd != change.alphaEnd)
		{
	        display.setAlpha(FX, emitter.alphaStart, emitter.alphaEnd);
	        change.alphaStart = emitter.alphaStart;
	        change.alphaEnd = emitter.alphaEnd;

		}

		if(displayChanged || emitter.gravity != change.gravity || emitter.gravityRand != change.gravityRand)
		{
	        display.setGravity(FX, emitter.gravity, emitter.gravityRand);
	        change.gravity = emitter.gravity;
	        change.gravityRand = emitter.gravityRand;
		}

		if(displayChanged || emitter.maxParticles != change.maxParticles || lifespanChanged)
		{
			emitter.particlesPerSec = 1 / (emitter.maxParticles / (emitter.lifespan + emitter.lifespanRand / 2));
			change.maxParticles = emitter.maxParticles;
		}
	}

	override public function nodeUpdate()
	{		
		if(hasComponent(Emitter))
		{				
			// Check for changes in the emitter and update the view accordingly
			setDisplay();

			if(emitter.active)
			{
				// Possibly fire more particles out
				if(display.particleCount < emitter.maxParticles)
				{
		        	emitter.elapsed += HXP.elapsed;  
		        	var needed:Int = Math.floor(emitter.elapsed / emitter.particlesPerSec);
		        	emitter.elapsed -= needed * emitter.particlesPerSec;

		        	for(i in 0...needed)
		        		fire();
				}

		    	// Stop emitter if we've created enough
		    	if(emitter.maxEmissions > 0 && emitter.totalEmissions >= emitter.maxEmissions)
    				emitter.active = false;
			}

			// Check if emitter should be marked as complete
			if(!emitter.complete)
			{
				if(emitter.waitForLifespan)
				{
					if(display.particleCount <= 0)
						emitter.complete = true;
				}
				else
				{
					if(!emitter.active)
						emitter.complete = true;
				}
			}

			// Emitter completed on previous update, check for auto-kill of component/entity
			else
			{
				if(emitter.destroyComponent)
					entity.remove(Emitter);

				else if(emitter.destroyEntity && entity.has(Display))
					entity.get(Display).destroyEntity = true;
			}
		}

		super.nodeUpdate();
	}

	public function fire()
	{
		// Emit particle within a rectangle
    	var px = emitter.position == null ? 0 : emitter.position.x;
    	var py = emitter.position == null ? 0 : emitter.position.y;
		if(emitter.emitRectRand != null)
		{
        	var ox = emitter.emitRectRand.x;
        	var oy = emitter.emitRectRand.y;
			display.emitInRectangle(FX, px + -ox / 2, py + -oy / 2, ox, oy);
		}

		// Emit particle within a radius
		else if(emitter.emitRadiusRand > 0)
			display.emitInCircle(FX, px, py, emitter.emitRadiusRand);

		// Emit particle at a specific point
    	else display.emit(FX, px, py);

    	emitter.totalEmissions++;
	}
}