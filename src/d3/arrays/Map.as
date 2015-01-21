package d3.arrays
{
	public class Map
	{
		
		protected static const d3_map_proto:String = "__proto__",
		protected static const d3_map_zero:String = "\0";
		protected var _:Object = {};
		
		public function Map()
		{
		}
		
		public function has(key:String):Boolean {
			return _.hasOwnProperty(d3_map_escape(key));
		}
		
		public function get(key:String):Object {
			return _[d3_map_escape(key)];
		}
		
		public function set(key:String, value:Object) {
			return _[d3_map_escape(key)] = value;
		}
		
		public function remove(key:String):Boolean {
			key = d3_map_escape(key);
			return _.hasOwnProperty(key) && delete _[key];
		}
		
		public function keys():Array {
			var keys:Array = [];
			for (var key:String in _) keys.push(d3_map_unescape(key));
			return keys;
		}
		
		public function values():Array {
			var values:Array = [];
			for (var key:String in _) values.push(_[key]);
			return values;	
		}
		
		public function entries():Array {
			var entries:Array = [];
			for (var key:String in _) entries.push(new Entry(d3_map_unescape(key), _[key]));
			return entries;
		}
		
		public function size():int {
			var size:int = 0;
			for (var key:String in _) ++size;
			return size;
		}
		
		public function empty():Boolean {
			for (var key:String in _) return false;
			return true;
		}
		
		public function forEach(f:Function) {
			for (var key:String in _) f.call(this, d3_map_unescape(key), _[key]);
		}
		
		protected function d3_map_escape(key:String):String {
			return key === d3_map_proto || key[0] === d3_map_zero ? d3_map_zero + key : key;
		}
		
		protected function d3_map_unescape(key:String):String {	
			return key[0] === d3_map_zero ? key.slice(1) : key;
		}
	}
}