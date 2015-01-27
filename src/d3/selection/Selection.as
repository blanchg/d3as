package d3.selection {

	var flexGlobals:Class = getDefinitionByName("FlexGlobals");
	var d3_documentElement = flexGlobals?flexGlobals.topLevelApplication:stage; // ?
	var d3_selectionRoot = d3.select(d3_documentElement);

	d3_array = function(list) {
		var i = list.length, array = new Array(i);
		while (i--) array[i] = list[i];
		return array;
	}
	
	d3_select = function(s, n) {
		return n.querySelector(s);
	}

	D3.selection = function() {
		return d3_selectionRoot;
	}

	D3.select = function(node:*) {
		var group = [typeof node === "string" ? d3_select(node, d3_document) : node];
		group.parentNode = d3_documentElement;
		return new Selection([group]);
	}

	D3.selectAll = function(nodes) {
		var group = d3_array(typeof nodes === "string" ? d3_selectAll(nodes, d3_document) : nodes);
		group.parentNode = d3_documentElement;
		return d3_selection([group]);
	}

	public class Selection extends Array {

		public function Selection(groups:Array) {
			for each (var group:Object in groups) {
				push(group);
			}
		}

	}
}