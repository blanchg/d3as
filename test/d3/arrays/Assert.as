package d3.arrays
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNull;
    import org.flexunit.asserts.assertStrictlyEquals;
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
        
        public function strictEqual(...args):void {
            injectContext(assertStrictlyEquals, args, 2);
        }
        
        public function isFalse(...args):void {
            injectContext(assertFalse, args, 1);
        }
        
        public function isTrue(...args):void {
            injectContext(assertTrue, args, 1);
        }
        
        public function isNaN(x:Number):void {
            injectContext(assertTrue, [x!=x], 1);
        }
        
        public function isNull(...args):void {
            injectContext(assertNull, args, 1);
        }
        
        public function isUndefined(...args):void {
            injectContext(assertNull, args, 1);
        }
        
        public function deepEqual(a:Object, b:Object):void {
            if (a is Array || b is Array) {
                assertTrue((context?context:"") + " a is not an array", a is Array);
                assertTrue((context?context:"") + " a is not an array", b is Array);
                assertEquals((context?context:"") + " Arrays of different length", a.length, b.length);
                for (var i:int in a) {
                    var aVal:Object = a[i];
                    var bVal:Object = b[i];
                    deepEqual(aVal, bVal);
                }
            } else {
                if (a is Number || a is String) {
                    assertEquals((context?context:"") + " Array contents are different", aVal, bVal);
                } else {
                    for (var aKey:String in a) {
                        deepEqual(a[aKey], b[aKey]);
                    }
                    for (var bKey:String in b) {
                        deepEqual(a[bKey], b[bKey]);
                    }
                }
            }
        }
        
        protected function injectContext(f:Function, args:Array, expected:int, before:Boolean = true):void {
            if (context && args.length == expected) {
                if (before)
                    args.unshift(context);
                else
                    args.push(context);
                f.apply(null, args);
            } else {
                f.apply(null, args);
            }
            context = null;
        }
    }
}