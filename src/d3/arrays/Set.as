package d3.arrays
{
    public class Set extends Base
    {
        public function Set()
        {
        }
        
        public function add(key:Object):Object {
            this._[key] = true;
            return key;
        }
        
        public function forEach(f:Function):void {
            for(var key:Object in _) f.call(this, key);
        }
    }
}