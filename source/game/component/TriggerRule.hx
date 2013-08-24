package game.component;

class TriggerRule
{
	public var type:String;
	public var typeValue:Int;
	public var terrainType:String;
	public var resultType:String;
	public var resultValue:Int;
	public var message:String;
	public var neighborType:String; // can be null
	public var neighborValue:Int;
	public var chance:Float = 1.0;
	public var min:Int = 0;
	public var max:Int = 8;

	public function new(type:String, typeValue:Int, terrainType:String,
		resultType:String, resultValue:Int, message:String, neighborType:String, 
		neighborValue:Int)
	{
		this.type = type;
		this.typeValue = typeValue;
		this.terrainType = (terrainType == null ? "any" : terrainType);
		this.resultType = resultType;
		this.resultValue = resultValue;
		this.message = message;
		this.neighborType = neighborType;
		this.neighborValue = neighborValue;

		if(type == null) throw("TriggerRule null type");
		if(resultType == null) throw("TriggerRule null resultType for type " + type);
		if(message == null) throw("TriggerRule null message for type " + type);
	}
}
