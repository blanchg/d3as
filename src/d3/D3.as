package d3
{
	import d3.arrays.Bisector;
	import d3.arrays.Entry;
	import d3.arrays.Map;

	public class D3
	{
		protected var bisector:Bisector = new Bisector(ascending);
		
		public function D3()
		{
		}
		
		// arrays/ascending
		public function ascending(a, b):int {
			return a < b ? -1 : a > b ? 1 : a >= b ? 0 : NaN;
		}
		
		// arrays/bisect
		public function bisect(a, x, lo, hi):Number {
			return bisector.bisect(a, x, lo, hi);
		}
		
		public function bisectRight(a:Array, x, lo:int = 0, hi:int = -1):Number {
			return bisector.right(a, x, lo, hi);
		}
		
		public function bisectLeft(a:Array, x, lo:int = 0, hi:int = -1):Number {
			return bisector.left(a, x, lo, hi);
		}
		
		// arrays/descending
		public function descending(a, b):int {
			return b < a ? -1 : b > a ? 1 : b >= a ? 0 : NaN;
		}
		
		// arrays/variation
		public function variance(array:Array, f:Function = null):Number {
			var n = array.length,
				m = 0,
				a,
				d,
				s = 0,
				i = -1,
				j = 0;
			if (f == null) {
				while (++i < n) {
					if (d3_numeric(a = d3_number(array[i]))) {
						d = a - m;
						m += d / ++j;
						s += d * (a - m);
					}
				}
			} else {
				while (++i < n) {
					if (d3_numeric(a = d3_number(f.call(array, array[i], i)))) {
						d = a - m;
						m += d / ++j;
						s += d * (a - m);
					}
				}
			}
			if (j > 1) return s / (j - 1);
		}
		
		// math/number
		public function d3_number(x:Number):Number {
			return x === null ? NaN : x;
		}
		
		public function d3_numeric(x:Number):Boolean {
			return !isNaN(x);
		}
		
		// arrays/deviation
		public function deviation(array:Array, f:Function = null):Number {
			var v:Number = variance(array, f);
			return v ? Math.sqrt(v) : v;
		}
		
		// arrays/entries
		public function entries(map:Object):Array {
			var entries:Array = [];
			for (var key:String in map) entries.push(new Entry(key, map[key]));
			return entries;
		}
		
		// arrays/extent
		public function extent(array:Array, f:Function = null):Array {
			var i = -1,
				n = array.length,
				a,
				b,
				c;
			if (f == null) {
				while (++i < n) if ((b = array[i]) != null && b >= b) { a = c = b; break; }
				while (++i < n) if ((b = array[i]) != null) {
					if (a > b) a = b;
					if (c < b) c = b;
				}
			} else {
				while (++i < n) if ((b = f.call(array, array[i], i)) != null && b >= b) { a = c = b; break; }
				while (++i < n) if ((b = f.call(array, array[i], i)) != null) {
					if (a > b) a = b;
					if (c < b) c = b;
				}
			}
			return [a, c];
		}
		
		// arrays/keys
		public function keys(map:Object):Array {
			var keys:Array = [];
			for (var key:String in map) keys.push(key);
			return keys;
		}
		
		// arrays/map
		public function map(object:Object, f:Function = null):Map {
			var map:Map = new Map();
			if (object instanceof Map) {
				Map(object).forEach(function(key:String, value:Object) {map.set(key, value); });
			} else if (object instanceof Array) {
				var i = -1,
					n = object.length,
					o;
				if (f == null) while (++i < n) map.set(i, object[i]);
				else while (++i < n) map.set(f.call(object, o = object[i], i), o);
			} else {
				for (var key in object) map.set(key, object[key]);
			}
			return map;s
		}
		
		public function max(array:Array, f:Function = null):Number {
			var i = -1,
				n = array.length,
				a,
				b;
			if (arguments.length === 1) {
				while (++i < n) if ((b = array[i]) != null && b >= b) { a = b; break; }
				while (++i < n) if ((b = array[i]) != null && b > a) a = b;
			} else {
				while (++i < n) if ((b = f.call(array, array[i], i)) != null && b >= b) { a = b; break; }
				while (++i < n) if ((b = f.call(array, array[i], i)) != null && b > a) a = b;
			}
			return a;
		}
	}
}