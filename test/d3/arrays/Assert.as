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
            var bKeys:Array = [];
            for (var bKey:Object in b) {
                bKeys.push(bKey);
            }
            for (var key:Object in a) {
                var aVal:Object = a[key];
                var index:int = bKeys.indexOf(key);
                assertTrue(index != -1, (context?context:"") + " b object doesn't contain key " + key);
                bKeys.splice(index, 1);
                var bVal:Object = b[key];
                if (aVal is Array || aVal is Object) {
                    deepEqual(aVal, bVal);
                } else {
                    assertEquals(aVal, bVal, (context?context:""));
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