package d3.arrays
{
    import d3.D3;

    public class Nest
    {
        
        protected var keys:Array = [];
        protected var _sortKeys:Array = [];
        protected var _sortValues:Function;
        protected var _rollup:Function = null;

        public function Nest()
        {
        }
        
        public function map(mapType:Function, array:Array, depth:int):Object {
            if (depth >= keys.length) return _rollup
                ? _rollup.call(Nest, array) : (_sortValues
                    ? array.sort(_sortValues)
                    : array);
            
            var i:int = -1,
                n:int = array.length,
                key:String = keys[depth++],
                keyValue:Object,
                object:Object,
                setter:Function,
                valuesByKey:Map = new Map(),
                values:Array;
            
            while (++i < n) {
                keyValue = key(object = array[i]);
                values = valuesByKey.get(keyValue + "") as Array;
                if (values) {
                    values.push(object);
                } else {
                    valuesByKey.set(keyValue + "", [object]);
                }
            }
            
            if (mapType != null) {
                object = mapType();
                setter = function(keyValue, values):void {
                    object.set(keyValue, map(mapType, values, depth));
                };
            } else {
                object = {};
                setter = function(keyValue, values):void {
                    object[keyValue] = map(mapType, values, depth);
                };
            }
            
            valuesByKey.forEach(setter);
            return object;
        }
        
        protected function _entries(map:Object, depth:int):Object {
            
            if (depth >= keys.length) return map;
            
            var array:Array = [],
                sortKey:Function = _sortKeys[depth++];
            
            map.forEach(function(key:String, keyMap:Object):void {
                array.push(new Entry(key, _entries(keyMap, depth)));
            });
            
            return sortKey
            ? array.sort(function(a, b):int { return sortKey(a.key, b.key); })
                : array;
        }
        
        public function entries(array:Array):Object {
            return _entries(map(D3.map, array, 0), 0);
        }
        
        public function key(d:String):Nest {
            keys.push(d);
            return this;
        }
        
        public function sortKeys(order:Function):Nest {
            _sortKeys[keys.length - 1] = order;
            return this;
        }
        
        public function sortValues(order:Function):Nest {
            _sortValues = order;
            return this;
        }
        
        public function rollup(f:Function):Nest {
            _rollup = f;
            return this;
        }
    }
}