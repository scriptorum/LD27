package game.component;

class TriggerRule
{
	public var objectType:String;
	public var terrainType:String;
	public var resultType:String;
	public var message:String;
	public var neighborType:String;
	public var chance:Float = 1.0;
	public var min:Int = 1;
	public var max:Int = 8;
	public var audio:String;

	public function new(objectType:String, terrainType:String, resultType:String,
		neighborType:String, message:String, audio:String)
	{
		this.objectType = objectType;
		this.terrainType = (terrainType == null ? "any" : terrainType);
		this.resultType = resultType;
		this.message = message;
		this.neighborType = neighborType;
		this.audio = audio;

		if(objectType == null) throw("TriggerRule null objectType");
		if(resultType == null) throw("TriggerRule null resultType for objectType " + objectType);
		if(message == null) throw("TriggerRule null message for objectType " + objectType);
	}
}
