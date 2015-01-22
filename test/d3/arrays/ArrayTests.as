package d3.arrays
{
    import d3.D3;
    

    public class ArrayTests extends D3
    {
        
        protected var assert:Assert = new Assert();
        
        protected var suite:Suite = new Suite(assert);
        
        public function load(name:String):Object {
            return {
                expression: function(expr:String):Function {
                    var key:String = expr.substr(expr.indexOf("d3.") + 3);
                    var f:Function = D3[key];
                    return f;
                }
            }
        }
        
        [Test]
        public function maxTest():void
        {
            var _:Class = D3;
            suite.addBatch({
                "max": {
                    topic: load("arrays/max").expression("d3.max"),
                    "returns the greatest numeric value for numbers": function(max) {
                        assert.equal(max([1]), 1);
                        assert.equal(max([5, 1, 2, 3, 4]), 5);
                        assert.equal(max([20, 3]), 20);
                        assert.equal(max([3, 20]), 20);
                    },
                    "returns the greatest lexicographic value for strings": function(max) {
                        assert.equal(max(["c", "a", "b"]), "c");
                        assert.equal(max(["20", "3"]), "3");
                        assert.equal(max(["3", "20"]), "3");
                    },
                    "ignores null, undefined and NaN": function(max) {
                        var o = {valueOf: function() { return NaN; }};
                        assert.equal(max([NaN, 1, 2, 3, 4, 5]), 5);
                        assert.equal(max([o, 1, 2, 3, 4, 5]), 5);
                        assert.equal(max([1, 2, 3, 4, 5, NaN]), 5);
                        assert.equal(max([1, 2, 3, 4, 5, o]), 5);
                        assert.equal(max([10, null, 3, undefined, 5, NaN]), 10);
                        assert.equal(max([-1, null, -3, undefined, -5, NaN]), -1);
                    },
                    "compares heterogenous types as numbers": function(max) {
                        assert.strictEqual(max([20, "3"]), 20);
                        assert.strictEqual(max(["20", 3]), "20");
                        assert.strictEqual(max([3, "20"]), "20");
                        assert.strictEqual(max(["3", 20]), 20);
                    },
                    "returns undefined for empty array": function(max) {
                        assert.isUndefined(max([]));
                        assert.isUndefined(max([null]));
                        assert.isUndefined(max([undefined]));
                        assert.isUndefined(max([NaN]));
                        assert.isUndefined(max([NaN, NaN]));
                    },
                    "applies the optional accessor function": function(max) {
                        assert.equal(max([[1, 2, 3, 4, 5], [2, 4, 6, 8, 10]], function(d) { return _.min(d); }), 2);
                        assert.equal(max([1, 2, 3, 4, 5], function(d, i) { return i; }), 4);
                    }
                }
            });
        }
        
        [Test]
        public function mapTest():void
        {
            
            function ascendingByKey(a, b) {
                return a.key.localeCompare(b.key);
            }
            
            suite.addBatch({
                "map": {
                    topic: load("arrays/map").expression("d3.map"),
                    "constructor": {
                        "map() returns an empty map": function(map) {
                            var m = map();
                            assert.deepEqual(m.keys(), []);
                        },
                        "map(null) returns an empty map": function(map) {
                            var m = map(null);
                            assert.deepEqual(m.keys(), []);
                        },
//                        "map(object) copies enumerable keys": function(map) {
//                            var m = map({foo: 42});
//                            assert.isTrue(m.has("foo"));
//                            assert.equal(m.get("foo"), 42);
//                            var m = map(Object.create(null, {foo: {value: 42, enumerable: true}}));
//                            assert.isTrue(m.has("foo"));
//                            assert.equal(m.get("foo"), 42);
//                        },
//                        "map(object) copies inherited keys": function(map) {
//                            function Foo() {}
//                            Foo.prototype.foo = 42;
//                            var m = map(Object.create({foo: 42}));
//                            assert.isTrue(m.has("foo"));
//                            assert.equal(m.get("foo"), 42);
//                            var m = map(new Foo());
//                            assert.isTrue(m.has("foo"));
//                            assert.equal(m.get("foo"), 42);
//                        },
//                        "map(object) does not copy non-enumerable keys": function(map) {
//                            var m = map({__proto__: 42}); // because __proto__ isn't enumerable
//                            assert.isFalse(m.has("__proto__"));
//                            assert.isUndefined(m.get("__proto__"));
//                            var m = map(Object.create(null, {foo: {value: 42, enumerable: false}}));
//                            assert.isFalse(m.has("foo"));
//                            assert.isUndefined(m.get("foo"));
//                        },
                        "map(map) copies the given map": function(map) {
                            var a = map({foo: 42}),
                            b = map(a);
                            assert.isTrue(b.has("foo"));
                            assert.equal(b.get("foo"), 42);
                            a.set("bar", true);
                            assert.isFalse(b.has("bar"));
                        },
                        "map(array) creates a map by index": function(map) {
                            assert.deepEqual(map(["foo", "bar"]).entries(), [{key: "0", value: "foo"}, {key: "1", value: "bar"}]);
                        },
                        "map(array) indexes missing elements in sparse arrays": function(map) {
                            assert.deepEqual(map(["foo", , "bar"]).entries(), [{key: "0", value: "foo"}, {key: "1", value: undefined}, {key: "2", value: "bar"}]);
                        },
                        "map(array, f) creates a map by accessor": function(map) {
                            assert.deepEqual(map([{field: "foo"}, {field: "bar"}], function(d) { return d.field; }).entries(), [{key: "foo", value: {field: "foo"}}, {key: "bar", value: {field: "bar"}}]);
                            assert.deepEqual(map([{field: "foo"}, {field: "bar"}], function(d, i) { return i; }).entries(), [{key: "0", value: {field: "foo"}}, {key: "1", value: {field: "bar"}}]);
                            assert.deepEqual(map([{field: "foo"}, {field: "bar"}], function(d, i) { return this[i].field; }).entries(), [{key: "foo", value: {field: "foo"}}, {key: "bar", value: {field: "bar"}}]);
                        }
                    },
                    "size": {
                        "returns the number of distinct keys": function(map) {
                            var m = map();
                            assert.deepEqual(m.size(), 0);
                            m.set("foo", 1);
                            assert.deepEqual(m.size(), 1);
                            m.set("foo", 2);
                            assert.deepEqual(m.size(), 1);
                            m.set("bar", 2);
                            assert.deepEqual(m.size(), 2);
                            m.remove("foo");
                            assert.deepEqual(m.size(), 1);
                            m.remove("foo");
                            assert.deepEqual(m.size(), 1);
                            m.remove("bar");
                            assert.deepEqual(m.size(), 0);
                        }
                    },
                    "empty": {
                        "returns true only if the map is empty": function(map) {
                            var m = map();
                            assert.isTrue(m.empty());
                            m.set("foo", 1);
                            assert.isFalse(m.empty());
                            m.set("foo", 2);
                            assert.isFalse(m.empty());
                            m.set("bar", 2);
                            assert.isFalse(m.empty());
                            m.remove("foo");
                            assert.isFalse(m.empty());
                            m.remove("foo");
                            assert.isFalse(m.empty());
                            m.remove("bar");
                            assert.isTrue(m.empty());
                        }
                    },
                    "forEach": {
                        "passes key and value": function(map) {
                            var m = map({foo: 1, bar: "42"}),
                            c = [];
                            m.forEach(function(k, v) { c.push([k, v]); });
                            c.sort(function(a, b) { return a[0].localeCompare(b[0]); });
                            assert.deepEqual(c, [["bar", "42"], ["foo", 1]]);
                        },
                        "uses the map as the context": function(map) {
                            var m = map({foo: 1, bar: "42"}),
                            c = [];
                            m.forEach(function() { c.push(this); });
                            assert.strictEqual(c[0], m);
                            assert.strictEqual(c[1], m);
                            assert.equal(c.length, 2);
                        },
                        "iterates in arbitrary order": function(map) {
                            var m1 = map({foo: 1, bar: "42"}),
                            m2 = map({bar: "42", foo: 1}),
                            c1 = [],
                            c2 = [];
                            m1.forEach(function(k, v) { c1.push([k, v]); });
                            m2.forEach(function(k, v) { c2.push([k, v]); });
                            c1.sort(function(a, b) { return a[0].localeCompare(b[0]); });
                            c2.sort(function(a, b) { return a[0].localeCompare(b[0]); });
                            assert.deepEqual(c1, c2);
                        }
                    },
                    "keys": {
                        "returns an array of string keys": function(map) {
                            var m = map({foo: 1, bar: "42"});
                            assert.deepEqual(m.keys().sort(), ["bar", "foo"]);
                        },
                        "properly unescapes zero-prefixed keys": function(map) {
                            var m = map();
                            m.set("__proto__", 42);
                            m.set("\0weird", 42);
                            assert.deepEqual(m.keys().sort(), ["\0weird", "__proto__"]);
                        }
                    },
                    "values": {
                        "returns an array of arbitrary values": function(map) {
                            var m = map({foo: 1, bar: "42"});
                            assert.deepEqual(m.values().sort(), [1, "42"]);
                        }
                    },
                    "entries": {
                        "returns an array of key-value objects": function(map) {
                            var m = map({foo: 1, bar: "42"});
                            assert.deepEqual(m.entries().sort(ascendingByKey), [{key: "bar", value: "42"}, {key: "foo", value: 1}]);
                        },
                        "empty maps have an empty entries array": function(map) {
                            var m = map();
                            assert.deepEqual(m.entries(), []);
                            m.set("foo", "bar");
                            assert.deepEqual(m.entries(), [{key: "foo", value: "bar"}]);
                            m.remove("foo");
                            assert.deepEqual(m.entries(), []);
                        },
                        "entries are returned in arbitrary order": function(map) {
                            var m = map({foo: 1, bar: "42"});
                            assert.deepEqual(m.entries().sort(ascendingByKey), [{key: "bar", value: "42"}, {key: "foo", value: 1}]);
                            var m = map({bar: "42", foo: 1});
                            assert.deepEqual(m.entries().sort(ascendingByKey), [{key: "bar", value: "42"}, {key: "foo", value: 1}]);
                        },
                        "observes changes via set and remove": function(map) {
                            var m = map({foo: 1, bar: "42"});
                            assert.deepEqual(m.entries().sort(ascendingByKey), [{key: "bar", value: "42"}, {key: "foo", value: 1}]);
                            m.remove("foo");
                            assert.deepEqual(m.entries(), [{key: "bar", value: "42"}]);
                            m.set("bar", "bar");
                            assert.deepEqual(m.entries(), [{key: "bar", value: "bar"}]);
                            m.set("foo", "foo");
                            assert.deepEqual(m.entries().sort(ascendingByKey), [{key: "bar", value: "bar"}, {key: "foo", value: "foo"}]);
                            m.remove("bar");
                            assert.deepEqual(m.entries(), [{key: "foo", value: "foo"}]);
                            m.remove("foo");
                            assert.deepEqual(m.entries(), []);
                            m.remove("foo");
                            assert.deepEqual(m.entries(), []);
                        }
                    },
                    "has": {
                        "empty maps do not have object built-ins": function(map) {
                            var m = map();
                            assert.isFalse(m.has("__proto__"));
                            assert.isFalse(m.has("hasOwnProperty"));
                        },
                        "can has keys using built-in names": function(map) {
                            var m = map();
                            m.set("__proto__", 42);
                            assert.isTrue(m.has("__proto__"));
                        },
                        "can has keys with null or undefined properties": function(map) {
                            var m = map();
                            m.set("", "");
                            m.set("null", null);
                            m.set("undefined", undefined);
                            assert.isTrue(m.has(""));
                            assert.isTrue(m.has("null"));
                            assert.isTrue(m.has("undefined"));
                        },
                        "coerces keys to strings": function(map) {
                            var m = map({"42": "foo", "null": 1, "undefined": 2});
                            assert.isTrue(m.has(42));
                            assert.isTrue(m.has(null));
                            assert.isTrue(m.has(undefined));
                        },
                        "returns the latest value": function(map) {
                            var m = map({foo: 42});
                            assert.isTrue(m.has("foo"));
                            m.set("foo", 43);
                            assert.isTrue(m.has("foo"));
                            m.remove("foo");
                            assert.isFalse(m.has("foo"));
                            m.set("foo", "bar");
                            assert.isTrue(m.has("foo"));
                        },
                        "returns undefined for missing keys": function(map) {
                            var m = map({foo: 42});
                            assert.isFalse(m.has("bar"));
                        }
                    },
                    "get": {
                        "empty maps do not have object built-ins": function(map) {
                            var m = map();
                            assert.isUndefined(m.get("__proto__"));
                            assert.isUndefined(m.get("hasOwnProperty"));
                        },
                        "can get keys using built-in names": function(map) {
                            var m = map();
                            m.set("__proto__", 42);
                            assert.equal(m.get("__proto__"), 42);
                        },
                        "coerces keys to strings": function(map) {
                            var m = map({"42": 1, "null": 2, "undefined": 3});
                            assert.equal(m.get(42), 1);
                            assert.equal(m.get(null), 2);
                            assert.equal(m.get(undefined), 3);
                        },
                        "returns the latest value": function(map) {
                            var m = map({foo: 42});
                            assert.equal(m.get("foo"), 42);
                            m.set("foo", 43);
                            assert.equal(m.get("foo"), 43);
                            m.remove("foo");
                            assert.isUndefined(m.get("foo"));
                            m.set("foo", "bar");
                            assert.equal(m.get("foo"), "bar");
                        },
                        "returns undefined for missing keys": function(map) {
                            var m = map({foo: 42});
                            assert.isUndefined(m.get("bar"));
                        }
                    },
                    "set": {
                        "returns the set value": function(map) {
                            var m = map();
                            assert.equal(m.set("foo", 42), 42);
                        },
                        "can set keys using built-in names": function(map) {
                            var m = map();
                            m.set("__proto__", 42);
                            assert.equal(m.get("__proto__"), 42);
                        },
                        "can set keys using zero-prefixed names": function(map) {
                            var m = map();
                            m.set("\0weird", 42);
                            assert.equal(m.get("\0weird"), 42);
                        },
                        "coerces keys to strings": function(map) {
                            var m = map();
                            m.set(42, 1);
                            assert.equal(m.get(42), 1);
                            m.set(null, 2);
                            assert.equal(m.get(null), 2);
                            m.set(undefined, 3);
                            assert.equal(m.get(undefined), 3);
                            assert.deepEqual(m.keys().sort(), ["42", "null", "undefined"]);
                        },
                        "can replace values": function(map) {
                            var m = map({foo: 42});
                            assert.equal(m.get("foo"), 42);
                            m.set("foo", 43);
                            assert.equal(m.get("foo"), 43);
                            m.set("foo", "bar");
                            assert.equal(m.get("foo"), "bar");
                        },
                        "can set null, undefined or empty string values": function(map) {
                            var m = map();
                            m.set("", "");
                            m.set("null", null);
                            m.set("undefined", undefined);
                            assert.equal(m.get(""), "");
                            assert.isNull(m.get("null"));
                            assert.isUndefined(m.get("undefined"));
                        }
                    }
                }
            });
        }
        
        [Test]
        public function keysTest():void
        {
            suite.addBatch({
                "keys": {
                    topic: load("arrays/keys").expression("d3.keys"),
                    "enumerates every defined key": function(keys) {
                        assert.deepEqual(keys({a: 1, b: 1}), ["a", "b"]);
                    },
                    "includes keys defined on prototypes": function(keys) {
                        function abc() {
                            this.a = 1;
                            this.b = 2;
                        }
                        abc.prototype.c = 3;
                        assert.deepEqual(keys(new abc()), ["a", "b", "c"]);
                    },
                    "includes keys with null or undefined values": function(keys) {
                        assert.deepEqual(keys({a: undefined, b: null, c: NaN}), ["a", "b", "c"]);
                    }
                }
            });
        }
        
        [Test]
        public function extentTest():void
        {
            suite.addBatch({
                "extent": {
                    topic: load("arrays/extent").expression("d3.extent"),
                    "returns the numeric extent for numbers": function(extent) {
                        assert.deepEqual(extent([1]), [1, 1]);
                        assert.deepEqual(extent([5, 1, 2, 3, 4]), [1, 5]);
                        assert.deepEqual(extent([20, 3]), [3, 20]);
                        assert.deepEqual(extent([3, 20]), [3, 20]);
                    },
                    "returns the lexicographic extent for strings": function(extent) {
                        assert.deepEqual(extent(["c", "a", "b"]), ["a", "c"]);
                        assert.deepEqual(extent(["20", "3"]), ["20", "3"]);
                        assert.deepEqual(extent(["3", "20"]), ["20", "3"]);
                    },
                    "ignores null, undefined and NaN": function(extent) {
                        var o = {valueOf: function() { return NaN; }};
                        assert.deepEqual(extent([NaN, 1, 2, 3, 4, 5]), [1, 5]);
                        assert.deepEqual(extent([o, 1, 2, 3, 4, 5]), [1, 5]);
                        assert.deepEqual(extent([1, 2, 3, 4, 5, NaN]), [1, 5]);
                        assert.deepEqual(extent([1, 2, 3, 4, 5, o]), [1, 5]);
                        assert.deepEqual(extent([10, null, 3, undefined, 5, NaN]), [3, 10]);
                        assert.deepEqual(extent([-1, null, -3, undefined, -5, NaN]), [-5, -1]);
                    },
                    "compares heterogenous types as numbers": function(extent) {
                        assert.deepEqual(extent([20, "3"]), ["3", 20]);
                        assert.deepEqual(extent(["20", 3]), [3, "20"]);
                        assert.deepEqual(extent([3, "20"]), [3, "20"]);
                        assert.deepEqual(extent(["3", 20]), ["3", 20]);
                    },
                    "returns undefined for empty array": function(extent) {
                        assert.deepEqual(extent([]), [undefined, undefined]);
                        assert.deepEqual(extent([null]), [undefined, undefined]);
                        assert.deepEqual(extent([undefined]), [undefined, undefined]);
                        assert.deepEqual(extent([NaN]), [undefined, undefined]);
                        assert.deepEqual(extent([NaN, NaN]), [undefined, undefined]);
                    },
                    "applies the optional accessor function exactly once": function(extent) {
                        var i = 10;
                        assert.deepEqual(extent([0,1,2,3], function() { return ++i; }), [11, 14]);
                    }
                }
            });
        }
        
        [Test]
        public function entriesTest():void
        {
            suite.addBatch({
                "entries": {
                    topic: load("arrays/entries").expression("d3.entries"),
                    "enumerates every entry": function(entries) {
                        assert.deepEqual(entries({a: 1, b: 2}), [
                            {key: "a", value: 1},
                            {key: "b", value: 2}
                        ]);
                    }//,
//                    "includes null or undefined values": function(entries) {
//                        var v = entries({a: undefined, b: null, c: NaN});
//                        assert.equal(v.length, 3);
//                        assert.deepEqual(v[0], {key: "a", value: undefined});
//                        assert.deepEqual(v[1], {key: "b", value: null});
//                        assert.equal(v[2].key, "c");
//                        assert.isNaN(v[2].value);
//                    }
                }
            });
        }
        
        [Test]
        public function deviationTest():void
        {
            suite.addBatch({
                "deviation": {
                    topic: load("arrays/deviation").expression("d3.deviation"),
                    "returns the sd value for numbers": function(deviation) {
                        assert.isNaN(deviation([1]));
                        assert.equal(deviation([5, 1, 2, 3, 4]), 1.5811388300841898);
                        assert.equal(deviation([20, 3]), 12.020815280171307);
                        assert.equal(deviation([3, 20]), 12.020815280171307);
                    },
                    "ignores null, undefined and NaN": function(deviation) {
                        assert.equal(deviation([NaN, 1, 2, 3, 4, 5]), 1.5811388300841898);
                        assert.equal(deviation([1, 2, 3, 4, 5, NaN]), 1.5811388300841898);
                        assert.equal(deviation([10, null, 3, undefined, 5, NaN]), 3.605551275463989);
                    },
                    "can handle large numbers without overflowing": function(deviation) {
                        assert.equal(deviation([Number.MAX_VALUE, Number.MAX_VALUE]), 0);
                        assert.equal(deviation([-Number.MAX_VALUE, -Number.MAX_VALUE]), 0);
                    },
                    "returns undefined for empty array": function(deviation) {
                        assert.isNaN(deviation([]));
                        assert.isNaN(deviation([null]));
                        assert.isNaN(deviation([undefined]));
                        assert.isNaN(deviation([NaN]));
                        assert.isNaN(deviation([NaN, NaN]));
                    },
                    "applies the optional accessor function": function(deviation) {
                        assert.equal(deviation([[1, 2, 3, 4, 5], [2, 4, 6, 8, 10]], mean), 2.1213203435596424);
                        assert.equal(deviation([1, 2, 3, 4, 5], function(d, i) { return i; }), 1.5811388300841898);
                    }
                }
            });
            
            function mean(array:Array, item:Object = null, j:int = -1) {
                var sum:int = 0;
                for each (var i:int in array) 
                {
                    sum += i;
                }
                
                return sum / array.length;
            }
        }
        
        [Test]
        public function descendingTest():void
        {
            suite.addBatch({
                "descending": {
                    topic: load("arrays/descending").expression("d3.descending"),
                    "numbers": {
                        "returns a negative number if a > b": function(descending) {
                            assert.isTrue(descending(1, 0) < 0);
                        },
                        "returns a positive number if a < b": function(descending) {
                            assert.isTrue(descending(0, 1) > 0);
                        },
                        "returns zero if a == b": function(descending) {
                            assert.equal(descending(0, 0), 0);
                        },
                        "returns NaN if a or b is undefined": function(descending) {
                            assert.isNaN(descending(0, undefined));
                            assert.isNaN(descending(undefined, 0));
                            assert.isNaN(descending(undefined, undefined));
                        },
                        "returns NaN if a or b is NaN": function(descending) {
                            assert.isNaN(descending(0, NaN));
                            assert.isNaN(descending(NaN, 0));
                            assert.isNaN(descending(NaN, NaN));
                        }
                    },
                    "strings": {
                        "returns a negative number if a > b": function(descending) {
                            assert.isTrue(descending("b", "a") < 0);
                        },
                        "returns a positive number if a < b": function(descending) {
                            assert.isTrue(descending("a", "b") > 0);
                        },
                        "returns zero if a == b": function(descending) {
                            assert.equal(descending("a", "a"), 0);
                        }
                    }
                }
            });
        }
        
        
        
        [Test]
        public function ascendingTest():void
        {
            
            suite.addBatch({
                "d3.ascending": {
                    topic: load("arrays/ascending").expression("d3.ascending"),
                    "numbers": {
                        "returns a negative number if a < b": function(ascending) {
                            assert.isTrue(ascending(0, 1) < 0);
                        },
                        "returns a positive number if a > b": function(ascending) {
                            assert.isTrue(ascending(1, 0) > 0);
                        },
                        "returns zero if a == b": function(ascending) {
                            assert.equal(ascending(0, 0), 0);
                        },
                        "returns NaN if a or b is undefined": function(ascending) {
                            assert.isNaN(ascending(0, undefined));
                            assert.isNaN(ascending(undefined, 0));
                            assert.isNaN(ascending(undefined, undefined));
                        },
                        "returns NaN if a or b is NaN": function(ascending) {
                            assert.isNaN(ascending(0, NaN));
                            assert.isNaN(ascending(NaN, 0));
                            assert.isNaN(ascending(NaN, NaN));
                        }
                    },
                    "strings": {
                        "returns a negative number if a < b": function(ascending) {
                            assert.isTrue(ascending("a", "b") < 0);
                        },
                        "returns a positive number if a > b": function(ascending) {
                            assert.isTrue(ascending("b", "a") > 0);
                        },
                        "returns zero if a == b": function(ascending) {
                            assert.equal(ascending("a", "a"), 0);
                        }
                    }
                }
            });
        }
        
        [Test]
        public function bisectTest():void
        {
            var _:Object = D3;
            var i30 = 1 << 30;
            
            suite.addBatch({
                "bisectLeft": {
                    topic: load("arrays/bisect").expression("d3.bisectLeft"),
                    "finds the index of an exact match": function(bisect) {
                        var array = [1, 2, 3];
                        assert.equal(bisect(array, 1), 0);
                        assert.equal(bisect(array, 2), 1);
                        assert.equal(bisect(array, 3), 2);
                    },
                    "finds the index of the first match": function(bisect) {
                        var array = [1, 2, 2, 3];
                        assert.equal(bisect(array, 1), 0);
                        assert.equal(bisect(array, 2), 1);
                        assert.equal(bisect(array, 3), 3);
                    },
                    "finds the insertion point of a non-exact match": function(bisect) {
                        var array = [1, 2, 3];
                        assert.equal(bisect(array, 0.5), 0);
                        assert.equal(bisect(array, 1.5), 1);
                        assert.equal(bisect(array, 2.5), 2);
                        assert.equal(bisect(array, 3.5), 3);
                    },
                    "has undefined behavior if the search value is unorderable": function(bisect) {
                        var array = [1, 2, 3];
                        bisect(array, new Date(NaN)); // who knows what this will return!
                        bisect(array, undefined);
                        bisect(array, NaN);
                    },
                    "observes the optional lower bound": function(bisect) {
                        var array = [1, 2, 3, 4, 5];
                        assert.equal(bisect(array, 0, 2), 2);
                        assert.equal(bisect(array, 1, 2), 2);
                        assert.equal(bisect(array, 2, 2), 2);
                        assert.equal(bisect(array, 3, 2), 2);
                        assert.equal(bisect(array, 4, 2), 3);
                        assert.equal(bisect(array, 5, 2), 4);
                        assert.equal(bisect(array, 6, 2), 5);
                    },
                    "observes the optional bounds": function(bisect) {
                        var array = [1, 2, 3, 4, 5];
                        assert.equal(bisect(array, 0, 2, 3), 2);
                        assert.equal(bisect(array, 1, 2, 3), 2);
                        assert.equal(bisect(array, 2, 2, 3), 2);
                        assert.equal(bisect(array, 3, 2, 3), 2);
                        assert.equal(bisect(array, 4, 2, 3), 3);
                        assert.equal(bisect(array, 5, 2, 3), 3);
                        assert.equal(bisect(array, 6, 2, 3), 3);
                    },
                    "large arrays": function(bisect) {
                        var array = [],
                        i = i30;
                        array[i++] = 1;
                        array[i++] = 2;
                        array[i++] = 3;
                        array[i++] = 4;
                        array[i++] = 5;
                        assert.equal(bisect(array, 0, i - 5, i), i - 5);
                        assert.equal(bisect(array, 1, i - 5, i), i - 5);
                        assert.equal(bisect(array, 2, i - 5, i), i - 4);
                        assert.equal(bisect(array, 3, i - 5, i), i - 3);
                        assert.equal(bisect(array, 4, i - 5, i), i - 2);
                        assert.equal(bisect(array, 5, i - 5, i), i - 1);
                        assert.equal(bisect(array, 6, i - 5, i), i - 0);
                    }
                },
                
                "bisectRight": {
                    topic: load("arrays/bisect").expression("d3.bisectRight"),
                    "finds the index after an exact match": function(bisect) {
                        var array = [1, 2, 3];
                        assert.equal(bisect(array, 1), 1);
                        assert.equal(bisect(array, 2), 2);
                        assert.equal(bisect(array, 3), 3);
                    },
                    "finds the index after the last match": function(bisect) {
                        var array = [1, 2, 2, 3];
                        assert.equal(bisect(array, 1), 1);
                        assert.equal(bisect(array, 2), 3);
                        assert.equal(bisect(array, 3), 4);
                    },
                    "finds the insertion point of a non-exact match": function(bisect) {
                        var array = [1, 2, 3];
                        assert.equal(bisect(array, 0.5), 0);
                        assert.equal(bisect(array, 1.5), 1);
                        assert.equal(bisect(array, 2.5), 2);
                        assert.equal(bisect(array, 3.5), 3);
                    },
                    "observes the optional lower bound": function(bisect) {
                        var array = [1, 2, 3, 4, 5];
                        assert.equal(bisect(array, 0, 2), 2);
                        assert.equal(bisect(array, 1, 2), 2);
                        assert.equal(bisect(array, 2, 2), 2);
                        assert.equal(bisect(array, 3, 2), 3);
                        assert.equal(bisect(array, 4, 2), 4);
                        assert.equal(bisect(array, 5, 2), 5);
                        assert.equal(bisect(array, 6, 2), 5);
                    },
                    "observes the optional bounds": function(bisect) {
                        var array = [1, 2, 3, 4, 5];
                        assert.equal(bisect(array, 0, 2, 3), 2);
                        assert.equal(bisect(array, 1, 2, 3), 2);
                        assert.equal(bisect(array, 2, 2, 3), 2);
                        assert.equal(bisect(array, 3, 2, 3), 3);
                        assert.equal(bisect(array, 4, 2, 3), 3);
                        assert.equal(bisect(array, 5, 2, 3), 3);
                        assert.equal(bisect(array, 6, 2, 3), 3);
                    },
                    "large arrays": function(bisect) {
                        var array = [],
                        i = i30;
                        array[i++] = 1;
                        array[i++] = 2;
                        array[i++] = 3;
                        array[i++] = 4;
                        array[i++] = 5;
                        assert.equal(bisect(array, 0, i - 5, i), i - 5);
                        assert.equal(bisect(array, 1, i - 5, i), i - 4);
                        assert.equal(bisect(array, 2, i - 5, i), i - 3);
                        assert.equal(bisect(array, 3, i - 5, i), i - 2);
                        assert.equal(bisect(array, 4, i - 5, i), i - 1);
                        assert.equal(bisect(array, 5, i - 5, i), i - 0);
                        assert.equal(bisect(array, 6, i - 5, i), i - 0);
                    }
                },
                
                "bisector(comparator)": {
                    topic: load("arrays/bisect").expression("d3.bisector"),
                    "left": {
                        topic: function(bisector) {
                            return bisector(function(d, x) { return _.descending(d.key, x); }).left;
                        },
                        "finds the index of an exact match": function(bisect) {
                            var array = [{key: 3}, {key: 2}, {key: 1}];
                            assert.equal(bisect(array, 3), 0);
                            assert.equal(bisect(array, 2), 1);
                            assert.equal(bisect(array, 1), 2);
                        },
                        "finds the index of the first match": function(bisect) {
                            var array = [{key: 3}, {key: 2}, {key: 2}, {key: 1}];
                            assert.equal(bisect(array, 3), 0);
                            assert.equal(bisect(array, 2), 1);
                            assert.equal(bisect(array, 1), 3);
                        },
                        "finds the insertion point of a non-exact match": function(bisect) {
                            var array = [{key: 3}, {key: 2}, {key: 1}];
                            assert.equal(bisect(array, 3.5), 0);
                            assert.equal(bisect(array, 2.5), 1);
                            assert.equal(bisect(array, 1.5), 2);
                            assert.equal(bisect(array, 0.5), 3);
                        },
                        "observes the optional lower bound": function(bisect) {
                            var array = [{key: 5}, {key: 4}, {key: 3}, {key: 2}, {key: 1}];
                            assert.equal(bisect(array, 6, 2), 2);
                            assert.equal(bisect(array, 5, 2), 2);
                            assert.equal(bisect(array, 4, 2), 2);
                            assert.equal(bisect(array, 3, 2), 2);
                            assert.equal(bisect(array, 2, 2), 3);
                            assert.equal(bisect(array, 1, 2), 4);
                            assert.equal(bisect(array, 0, 2), 5);
                        },
                        "observes the optional bounds": function(bisect) {
                            var array = [{key: 5}, {key: 4}, {key: 3}, {key: 2}, {key: 1}];
                            assert.equal(bisect(array, 6, 2, 3), 2);
                            assert.equal(bisect(array, 5, 2, 3), 2);
                            assert.equal(bisect(array, 4, 2, 3), 2);
                            assert.equal(bisect(array, 3, 2, 3), 2);
                            assert.equal(bisect(array, 2, 2, 3), 3);
                            assert.equal(bisect(array, 1, 2, 3), 3);
                            assert.equal(bisect(array, 0, 2, 3), 3);
                        },
                        "large arrays": function(bisect) {
                            var array = [],
                            i = i30;
                            array[i++] = {key: 5};
                            array[i++] = {key: 4};
                            array[i++] = {key: 3};
                            array[i++] = {key: 2};
                            array[i++] = {key: 1};
                            assert.equal(bisect(array, 6, i - 5, i), i - 5);
                            assert.equal(bisect(array, 5, i - 5, i), i - 5);
                            assert.equal(bisect(array, 4, i - 5, i), i - 4);
                            assert.equal(bisect(array, 3, i - 5, i), i - 3);
                            assert.equal(bisect(array, 2, i - 5, i), i - 2);
                            assert.equal(bisect(array, 1, i - 5, i), i - 1);
                            assert.equal(bisect(array, 0, i - 5, i), i - 0);
                        }
                    },
                    "right": {
                        topic: function(bisector) {
                            return bisector(function(d, x) { return _.ascending(d.key, x); }).right;
                        },
                        "finds the index after an exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 1);
                            assert.equal(bisect(array, 2), 2);
                            assert.equal(bisect(array, 3), 3);
                        },
                        "finds the index after the last match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 1);
                            assert.equal(bisect(array, 2), 3);
                            assert.equal(bisect(array, 3), 4);
                        },
                        "finds the insertion point of a non-exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 0.5), 0);
                            assert.equal(bisect(array, 1.5), 1);
                            assert.equal(bisect(array, 2.5), 2);
                            assert.equal(bisect(array, 3.5), 3);
                        },
                        "observes the optional lower bound": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2), 2);
                            assert.equal(bisect(array, 1, 2), 2);
                            assert.equal(bisect(array, 2, 2), 2);
                            assert.equal(bisect(array, 3, 2), 3);
                            assert.equal(bisect(array, 4, 2), 4);
                            assert.equal(bisect(array, 5, 2), 5);
                            assert.equal(bisect(array, 6, 2), 5);
                        },
                        "observes the optional bounds": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2, 3), 2);
                            assert.equal(bisect(array, 1, 2, 3), 2);
                            assert.equal(bisect(array, 2, 2, 3), 2);
                            assert.equal(bisect(array, 3, 2, 3), 3);
                            assert.equal(bisect(array, 4, 2, 3), 3);
                            assert.equal(bisect(array, 5, 2, 3), 3);
                            assert.equal(bisect(array, 6, 2, 3), 3);
                        },
                        "large arrays": function(bisect) {
                            var array = [],
                            i = i30;
                            array[i++] = {key: 1};
                            array[i++] = {key: 2};
                            array[i++] = {key: 3};
                            array[i++] = {key: 4};
                            array[i++] = {key: 5};
                            assert.equal(bisect(array, 0, i - 5, i), i - 5);
                            assert.equal(bisect(array, 1, i - 5, i), i - 4);
                            assert.equal(bisect(array, 2, i - 5, i), i - 3);
                            assert.equal(bisect(array, 3, i - 5, i), i - 2);
                            assert.equal(bisect(array, 4, i - 5, i), i - 1);
                            assert.equal(bisect(array, 5, i - 5, i), i - 0);
                            assert.equal(bisect(array, 6, i - 5, i), i - 0);
                        }
                    }
                },
                
                "bisector(accessor)": {
                    topic: load("arrays/bisect").expression("d3.bisector"),
                    "left": {
                        topic: function(bisector) {
                            return bisector(function(d) { return d.key; }).left;
                        },
                        "finds the index of an exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 0);
                            assert.equal(bisect(array, 2), 1);
                            assert.equal(bisect(array, 3), 2);
                        },
                        "finds the index of the first match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 0);
                            assert.equal(bisect(array, 2), 1);
                            assert.equal(bisect(array, 3), 3);
                        },
                        "finds the insertion point of a non-exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 0.5), 0);
                            assert.equal(bisect(array, 1.5), 1);
                            assert.equal(bisect(array, 2.5), 2);
                            assert.equal(bisect(array, 3.5), 3);
                        },
                        "observes the optional lower bound": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2), 2);
                            assert.equal(bisect(array, 1, 2), 2);
                            assert.equal(bisect(array, 2, 2), 2);
                            assert.equal(bisect(array, 3, 2), 2);
                            assert.equal(bisect(array, 4, 2), 3);
                            assert.equal(bisect(array, 5, 2), 4);
                            assert.equal(bisect(array, 6, 2), 5);
                        },
                        "observes the optional bounds": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2, 3), 2);
                            assert.equal(bisect(array, 1, 2, 3), 2);
                            assert.equal(bisect(array, 2, 2, 3), 2);
                            assert.equal(bisect(array, 3, 2, 3), 2);
                            assert.equal(bisect(array, 4, 2, 3), 3);
                            assert.equal(bisect(array, 5, 2, 3), 3);
                            assert.equal(bisect(array, 6, 2, 3), 3);
                        },
                        "large arrays": function(bisect) {
                            var array = [],
                            i = i30;
                            array[i++] = {key: 1};
                            array[i++] = {key: 2};
                            array[i++] = {key: 3};
                            array[i++] = {key: 4};
                            array[i++] = {key: 5};
                            assert.equal(bisect(array, 0, i - 5, i), i - 5);
                            assert.equal(bisect(array, 1, i - 5, i), i - 5);
                            assert.equal(bisect(array, 2, i - 5, i), i - 4);
                            assert.equal(bisect(array, 3, i - 5, i), i - 3);
                            assert.equal(bisect(array, 4, i - 5, i), i - 2);
                            assert.equal(bisect(array, 5, i - 5, i), i - 1);
                            assert.equal(bisect(array, 6, i - 5, i), i - 0);
                        }
                    },
                    "right": {
                        topic: function(bisector) {
                            return bisector(function(d) { return d.key; }).right;
                        },
                        "finds the index after an exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 1);
                            assert.equal(bisect(array, 2), 2);
                            assert.equal(bisect(array, 3), 3);
                        },
                        "finds the index after the last match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 1), 1);
                            assert.equal(bisect(array, 2), 3);
                            assert.equal(bisect(array, 3), 4);
                        },
                        "finds the insertion point of a non-exact match": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}];
                            assert.equal(bisect(array, 0.5), 0);
                            assert.equal(bisect(array, 1.5), 1);
                            assert.equal(bisect(array, 2.5), 2);
                            assert.equal(bisect(array, 3.5), 3);
                        },
                        "observes the optional lower bound": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2), 2);
                            assert.equal(bisect(array, 1, 2), 2);
                            assert.equal(bisect(array, 2, 2), 2);
                            assert.equal(bisect(array, 3, 2), 3);
                            assert.equal(bisect(array, 4, 2), 4);
                            assert.equal(bisect(array, 5, 2), 5);
                            assert.equal(bisect(array, 6, 2), 5);
                        },
                        "observes the optional bounds": function(bisect) {
                            var array = [{key: 1}, {key: 2}, {key: 3}, {key: 4}, {key: 5}];
                            assert.equal(bisect(array, 0, 2, 3), 2);
                            assert.equal(bisect(array, 1, 2, 3), 2);
                            assert.equal(bisect(array, 2, 2, 3), 2);
                            assert.equal(bisect(array, 3, 2, 3), 3);
                            assert.equal(bisect(array, 4, 2, 3), 3);
                            assert.equal(bisect(array, 5, 2, 3), 3);
                            assert.equal(bisect(array, 6, 2, 3), 3);
                        },
                        "large arrays": function(bisect) {
                            var array = [],
                            i = i30;
                            array[i++] = {key: 1};
                            array[i++] = {key: 2};
                            array[i++] = {key: 3};
                            array[i++] = {key: 4};
                            array[i++] = {key: 5};
                            assert.equal(bisect(array, 0, i - 5, i), i - 5);
                            assert.equal(bisect(array, 1, i - 5, i), i - 4);
                            assert.equal(bisect(array, 2, i - 5, i), i - 3);
                            assert.equal(bisect(array, 3, i - 5, i), i - 2);
                            assert.equal(bisect(array, 4, i - 5, i), i - 1);
                            assert.equal(bisect(array, 5, i - 5, i), i - 0);
                            assert.equal(bisect(array, 6, i - 5, i), i - 0);
                        }
                    }
                }
            });
        }
    }
}