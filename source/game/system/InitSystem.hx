package game.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Entity;

import com.haxepunk.HXP;

import game.service.EntityService;
import game.component.Application;

/*
 * In charge of maintenance of game scenes/modes including intialization of the main game.
 */

class InitSystem extends System
{
	private var app:Application;

	public var factory:EntityService;
	public var engine:Engine;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
		this.app = factory.getApplication();
	}

	override public function update(time:Float)
	{
		if(app.init == false)
			return;

		initMode();
	}

	private function initMode()
	{
		// trace("Initializing mode:" + app.mode);
		factory.transitionTo(app.mode);

		switch(app.mode)
		{
			case INIT:
			factory.startInit();
			app.changeMode(MENU);
			initMode(); // immediately transition to above mode

			case MENU:
			// factory.startMenu();

			case GAME:
			// factory.startLevel();

			case CREDITS:
		}

		app.init = false;
	}
}