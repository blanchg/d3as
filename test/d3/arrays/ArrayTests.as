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