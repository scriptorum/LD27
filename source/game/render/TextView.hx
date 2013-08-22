package game.render;

import game.component.Text;// Note that you must set a totally new TextStyle object for a style change to be recognized
import game.component.Alpha;
import game.render.FancyText;

class TextView extends View
{
	private var curMessage:String;
	private var curStyle:TextStyle;
	private var display:FancyText;

	override public function begin()
	{
		nodeUpdate();
	}

	private function setText(text:Text)
	{
		var style = text.style;
		if(style == null)
			style = new TextStyle(0xFFFFFF, 14, "font/04B_03__.ttf");

		if(graphic == null)
			graphic = display = new FancyText(text.message, style.color, style.size, 0, 0, 1, style.font);
		else display.setString(text.message);

		curMessage = text.message;
		curStyle = text.style;
	}

	override public function nodeUpdate()
	{
		super.nodeUpdate();

		// Image with Tile
		if(hasComponent(Text))
		{
			var text:Text = getComponent(Text);
			if(curMessage == null || text.message != curMessage || text.style != curStyle)
				setText(text);
		}
		else
		{
			// trace(entity.name + " Setting display to null");
			display = null;
			return;
		}

		// Update alpha/transparency
		if(hasComponent(Alpha))
		{
			var alpha:Float = getComponent(Alpha).value;
			if(alpha != display.getAlpha())
				display.setAlpha(alpha);
		}

	}
}