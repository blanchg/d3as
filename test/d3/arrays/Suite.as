package d3.arrays
{

    public class Suite
    {
        public var assert:Assert;
        
        public function Suite(assert:Assert) {
            this.assert = assert;
        }
        
        public function addBatch(batch:Object):void {
            for (var key:String in batch) {
//                trace("Key: " + key);
                var value:Object = batch[key];
                var topic:Object = value.topic;
                
                for (var description:String in value) {
                    if (description == "topic")
                        continue;
//                    trace("  " + description);
                    assert.context = key + " - " + description;
                    var o:Object = value[description];
                    if (o is Function) {
                        var f:Function = o as Function;
                        try {
                            f.call(this, topic);
                        } catch (e) {
                            trace(key + " - " + description + " failed");
                            throw(e);
                        }
                    } else {
                        addBatch(o);
                    }
                }
            }
        }
        
    }
}