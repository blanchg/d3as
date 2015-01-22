package d3.arrays
{
	public class Map extends Base
	{
		
		public function Map()
		{
		}
		
		public function get(key:Object):Object {
			return _[key];
		}
		
		public function set(key:Object, value:Object):Object {
			return _[key] = value;
		}
		
		public function keys():Array {
			var keys:Array = [];
			for (var key:Object in _) keys.push(key);
			return keys;
		}
		
		public function entries():Array {
			var entries:Array = [];
			for (var key:Object in _) entries.push(new Entry(key, _[key]));
			return entries;
		}
		
		public function forEach(f:Function):void {
			for (var key:Object in _) f.call(this, key, _[key]);
		}
	}
}