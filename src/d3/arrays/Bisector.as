package d3.arrays
{
	public class Bisector
	{
		protected var compare:Function;
		
		public function Bisector(compare:Function)
		{
			this.compare = compare;
		}
		
		public function bisect(a:Array, x, lo:int = 0, hi:int = -1):Number {
			return right(a, x, lo, hi);
		}
		
		public function right(a:Array, x, lo:int = 0, hi:int = -1):Number {
			if (hi == -1) {
				hi = a.length;
			}
			while (lo < hi) {
				var mid = lo + hi >>> 1;
				if (compare(a[mid], x) > 0) hi = mid;
				else lo = mid + 1;
			}
			return lo;
		}
		
		public function left(a:Array, x, lo:int = 0, hi:int = -1):Number {
			if (hi == -1) {
				hi = a.length;
			}
			while (lo < hi) {
				var mid = lo + hi >>> 1;
				if (compare(a[mid], x) < 0) lo = mid + 1;
				else hi = mid;
			}
			return lo;
		}
	}
}