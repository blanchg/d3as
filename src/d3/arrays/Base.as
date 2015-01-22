package d3.arrays
{
    import flash.utils.Dictionary;

    public class Base
    {
        
        protected static const d3_map_proto:String = "__proto__";
        protected static const d3_map_zero:String = "\0";
        protected var _:Dictionary = new Dictionary();
        
        public function Base()
        {
        }
        
        public function has(key:Object):Boolean {
            return _.hasOwnProperty(key);
        }
        
        public function remove(key:Object):Boolean {
            return _.hasOwnProperty(key) && delete _[key];
        }
        
        public function values():Array {
            var values:Array = [];
            for (var key:Object in _) values.push(_[key]);
            return values;	
        }
        
        public function size():int {
            var size:int = 0;
            for (var key:Object in _) ++size;
            return size;
        }
        
        public function empty():Boolean {
            for (var key:Object in _) return false;
            return true;
        }
        
    }
}