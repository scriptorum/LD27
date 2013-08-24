package game.component;

class TriggerRule
{
	public var type:String;
	public var terrain:String;
	public var resultType:String;
	public var message:String;
	public var neighbor:String; // can be null
	public var chance:Float = 1.0;
	public var min:Int = 1;
	public var max:Int = 8;

	public function new(type:String, terrain:String, resultType:String, message:String, neighbor:String)
	{
		this.type = type;
		this.terrain = (terrain == null ? "any" : terrain);
		this.resultType = resultType;
		this.message = message;
		this.neighbor = neighbor;

		if(type == null) throw("TriggerRule null type");
		if(resultType == null) throw("TriggerRule null resultType for type " + type);
		if(message == null) throw("TriggerRule null message for type " + type);
	}
}

		// <trigger terrain="water" neighbor="lava" min="5" max="8" result="steam" message="Some water evaporates"/>
		// <trigger terrain="any" neighbor="meteor" chance="0.8" result="mineral" message="A meteor spreads minerals"/>
		// <trigger terrain="land" neighbor="algae" min="2" max="8" result="plant" message="A plant grows from nearby algae"/>
