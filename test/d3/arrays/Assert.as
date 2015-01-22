package d3.arrays
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNull;
    import org.flexunit.asserts.assertTrue;

    public class Assert
    {
        public var context:String = null;
        
        public function Assert()
        {
        }
        
        public function equal(a,b,c=null):void {
            var args:Array = [b,a];
            if (c)
                args.push(c);
            injectContext(assertEquals, args, 2);
        }
        
        public function isTrue(...args):void {
            injectContext(assertTrue, args, 1);
        }
        
        public function isNaN(x:Number):void {
            injectContext(assertTrue, [x!=x], 1);
        }
        
        public function isUndefined(...args):void {
            injectContext(assertNull, args, 1);
        }
        
        public function deepEqual(a:Object, b:Object):void {
            if (a is Array || b is Array) {
                assertTrue(a is Array, (context?context:"") + " a is not an array");
                assertTrue(b is Array, (context?context:"") + " a is not an array");
                assertEquals(a.length, b.length, (context?context:"") + " Arrays of different length");
                for (var i:int in a) {
                    var aVal:Object = a[i];
                    var bVal:Object = b[i];
                    if (aVal is Array || bVal is Array) {
                        deepEqual(aVal, bVal);
                    } else {
                        assertEquals(aVal, bVal, (context?context:"") + " Array contents are different");
                    }
                }
            }
        }
        
        protected function injectContext(f:Function, args:Array, expected:int):void {
            if (context && args.length == expected) {
                args.unshift(context);
                f.apply(null, args);
            } else {
                f.apply(null, args);
            }
            context = null;
        }
    }
}