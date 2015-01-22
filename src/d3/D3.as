package d3
{
	import d3.arrays.Bisector;
	import d3.arrays.Entry;
	import d3.arrays.Map;
	import d3.arrays.Nest;
	import d3.arrays.Set;

	public class D3
	{
		protected static var _bisector:Bisector = new Bisector(ascending);
		
		public function D3()
		{
		}
		
		// arrays/ascending
		public static function ascending(a:Object, b:Object):Number {
            if (a == null || b == null)
                return NaN;
			return a < b ? -1 : a > b ? 1 : a >= b ? 0 : NaN;
		}
        
        public static function bisector(f:Function = null):Bisector {
            if (f) {
                return new Bisector(f);
            } else {
                return _bisector;
            }
        }
		
		// arrays/bisect
		public static function bisect(a:Array, x:Object, lo:int = 0, hi:int = -1):Number {
			return _bisector.bisect(a, x, lo, hi);
		}
		
		public static function bisectRight(a:Array, x:Object, lo:int = 0, hi:int = -1):Number {
			return _bisector.right(a, x, lo, hi);
		}
		
		public static function bisectLeft(a:Array, x:Object, lo:int = 0, hi:int = -1):Number {
			return _bisector.left(a, x, lo, hi);
		}
		
		// arrays/descending
		public static function descending(a, b):Number {
            if (a == null || b == null)
                return NaN;
			return b < a ? -1 : b > a ? 1 : b >= a ? 0 : NaN;
		}
		
		// arrays/variation
		public static function variance(array:Array, f:Function = null):Number {
			var n:int = array.length,
				m:Number = 0,
				a:Number,
				d:Number,
				s:Number = 0,
				i:int = -1,
				j:int = 0;
			if (f == null) {
				while (++i < n) {
                    a = d3_number(array[i]);
					if (d3_numeric(a)) {
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
            return NaN;
		}
		
		// math/number
		public static function d3_number(x:Object):Number {
			return x == null || !(x is Number)?NaN:Number(x);
		}
		
		public static function d3_numeric(x:Object):Boolean {
			return x is Number && x==x;
		}
		
		// arrays/deviation
		public static function deviation(array:Array, f:Function = null):Number {
			var v:Number = variance(array, f);
			return v ? Math.sqrt(v) : v;
		}
		
		// arrays/entries
		public static function entries(map:Object):Array {
			var entries:Array = [];
			for (var key:String in map) entries.push(new Entry(key, map[key]));
			return entries;
		}
		
		// arrays/extent
		public static function extent(array:Array, f:Function = null):Array {
			var i:int = -1,
				n:int = array.length,
				a:Number,
				b:Number,
				c:Number;
			if (f == null) {
				while (++i < n) { b = array[i]; if (b >= b) { a = c = b; break; } }
				while (++i < n) { b = array[i]; if (b == b) {
					if (a > b) a = b;
					if (c < b) c = b;
				} }
			} else {
				while (++i < n) { b = f.call(array, array[i], i); if (b >= b) { a = c = b; break; } }
				while (++i < n) { b = f.call(array, array[i], i);
                    if (b == b) {
    					if (a > b) a = b;
    					if (c < b) c = b;
    				}
                }
			}
			return [a, c];
		}
		
		// arrays/keys
		public static function keys(map:Object):Array {
			var keys:Array = [];
			for (var key:String in map) keys.push(key);
			return keys;
		}
		
		// arrays/map
		public static function map(object:Object = null, f:Function = null):Map {
			var map:Map = new Map();
			if (object is Map) {
				Map(object).forEach(function(key:String, value:Object):void {map.set(key, value); });
			} else if (object is Array) {
				var i:int = -1,
					n:int = object.length,
					o:Object;
				if (f == null) while (++i < n) map.set("" + i, object[i]);
				else while (++i < n) map.set(f.call(object, o = object[i], i), o);
			} else {
				for (var key:String in object) map.set(key, object[key]);
			}
			return map;
		}
		
        // arrays/max
		public static function max(array:Array, f:Function = null):Object {
			var i:int = -1,
				n:int = array.length,
				a:Object,
				b:Object;
			if (f == null) {
				while (++i < n) if ((b = array[i]) != null && b >= b) { a = b; break; }
				while (++i < n) if ((b = array[i]) != null && b > a) a = b;
			} else {
				while (++i < n) if ((b = f.call(array, array[i], i)) != null && b >= b) { a = b; break; }
				while (++i < n) if ((b = f.call(array, array[i], i)) != null && b > a) a = b;
			}
			return a;
		}
        
        // arrays/mean
        public static function mean(array:Array, f:Function = null):Number {
            var s:int = 0,
                n:int = array.length,
                a:Number,
                i:int = -1,
                j:int = n;
            if (f == null) {
                while (++i < n) if (d3_numeric(a = d3_number(array[i]))) s += a; else --j;
            } else {
                while (++i < n) if (d3_numeric(a = d3_number(f.call(array, array[i], i)))) s += a; else --j;
            }
            if (j) return s / j;
            return NaN;
        }
        
        // arrays/median
        public static function median(array:Array, f:Function = null):Number {
            var numbers:Array = [],
                n:int = array.length,
                a:Number,
                i:int = -1;
            if (f == null) {
                while (++i < n) if (d3_numeric(a = d3_number(array[i]))) numbers.push(a);
            } else {
                while (++i < n) if (d3_numeric(a = d3_number(f.call(array, array[i], i)))) numbers.push(a);
            }
            if (numbers.length) return quantile(numbers.sort(ascending), .5);
            return NaN;
        }
        
        // arrays/quantile
        public static function quantile(values:Array, p:Number):Number {
            var H:Number = (values.length - 1) * p + 1,
                h:int = Math.floor(H),
                v:Number = +values[h - 1],
                e:Number = H - h;
            return e ? v + e * (values[h] - v) : v;
        }

        // arrays/merge
        public static function merge(arrays:Array):Array {
            var n:int = arrays.length,
                m:int,
                i:int = -1,
                j:int = 0,
                merged:Array,
                array:Array;
            
            while (++i < n) j += arrays[i].length;
            merged = new Array(j);
            
            while (--n >= 0) {
                array = arrays[n];
                m = array.length;
                while (--m >= 0) {
                    merged[--j] = array[m];
                }
            }
            
            return merged;
        }
        
        // arrays/min
        public static function min(array:Array, f:Function = null):Object {
            var i:int = -1,
                n:int = array.length,
                a:Object,
                b:Object;
            if (f == null) {
                while (++i < n) if ((b = array[i]) != null && b >= b) { a = b; break; }
                while (++i < n) if ((b = array[i]) != null && a > b) a = b;
            } else {
                while (++i < n) if ((b = f.call(array, array[i], i)) != null && b >= b) { a = b; break; }
                while (++i < n) if ((b = f.call(array, array[i], i)) != null && a > b) a = b;
            }
            return a;
        }
        
        // arrays/nest
        public static function nest():Nest {
            return new Nest();
        }
        
        // arrays/pairs
        public static function pairs(array:Array):Array {
            var i:int = 0, n:int = array.length - 1, p0:Array, p1:Array = array[0], pairs:Array = new Array(n < 0 ? 0 : n);
            while (i < n) pairs[i] = [p0 = p1, p1 = array[++i]];
            return pairs;
        }
        
        // arrays/permute
        public static function permute(array:Array, indexes:Array):Array {
            var i:int = indexes.length, permutes:Array = new Array(i);
            while (i--) permutes[i] = array[indexes[i]];
            return permutes;
        }
        
        // arrays/range
        protected static function d3_range_integerScale(x:Number):Number {
            var k:Number = 1;
            while (x * k % 1) k *= 10;
            return k;
        }
        
        public static function range(start, stop:int = 0, step:int = 1):Array {
            if (stop == 0) {
                stop = start;
                start = 0;
            }
            if ((stop - start) / step === Infinity) throw new Error("infinite range");
            var range:Array = [],
                k:Number = d3_range_integerScale(Math.abs(step)),
                i:int = -1,
                j:int;
            start *= k, stop *= k, step *= k;
            if (step < 0) while ((j = start + step * ++i) > stop) range.push(j / k);
            else while ((j = start + step * ++i) < stop) range.push(j / k);
            return range;
        }
        
        // arrays/set
        public static function sett(array:Array):Set {
            var sett:Set = new Set();
            if (array) for (var i:int = 0, n:int = array.length; i < n; ++i) sett.add(array[i]);
            return sett;
        }
        
        // arrays/shuffle
        public static function shuffle(array:Array, i0:int = 0, i1:int = -1):Array {
            if (i1 == -1)
                i1 = array.length;
            
            var m:int = i1 - i0, t:Number, i:Number;
            while (m) {
                i = Math.random() * m--;
                t = array[m + i0], array[m + i0] = array[i + i0], array[i + i0] = t;
            }
            return array;
        }
        
        // arrays/sum
        public static function sum(array:Array, f:Function = null):Number {
            var s:Number = 0,
                n:int = array.length,
                a:Number,
                i:int = -1;
            if (arguments.length === 1) {
                while (++i < n) if (d3_numeric(a = +array[i])) s += a; // zero and null are equivalent
            } else {
                while (++i < n) if (d3_numeric(a = +f.call(array, array[i], i))) s += a;
            }
            return s;
        }
        
        // arrays/zip
        protected static function d3_zipLength(d:Array):int {
            return d.length;
        }
        
        public static function zip(...arguments):Array {
            var n:int = arguments.length;
            if (n == 0) return [];
            for (var i:int = -1, m:int = Number(min(arguments, d3_zipLength)), zips:Array = new Array(m); ++i < m;) {
                for (var j:int = -1, zip:Array = zips[i] = new Array(n); ++j < n;) {
                    zip[j] = arguments[j][i];
                }
            }
            return zips;
        }
        
        // arrays/transpose
        public static function transpose(matrix:Array):Array {
            return zip.apply(null, matrix);
        }
        
        // arrays/values
        public static function values(map:Object):Array {
            var values:Array = [];
            for (var key:String in map) values.push(map[key]);
            return values;
        }
	}
}