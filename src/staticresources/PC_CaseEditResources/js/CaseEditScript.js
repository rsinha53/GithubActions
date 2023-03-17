fetchLayout = function() {
	var result = sforce.connection.describeLayout("Case", new Array(RecordTypeId));
	var layouts = result.getArray("layouts");
	for (var i=0; i<layouts.length; i++) {
		var layout = layouts[0];
		//console.log(JSON.stringify(layout.getArray('editLayoutSections')));
		//caseLayout = JSON.stringify(layout.getArray('editLayoutSections'));    // Executing code
		// Below code assures the same structure irrespective of having one or more items.
		ls = layout.getArray('editLayoutSections');
		if (ls.constructor != Array) {
			ls = [ls];
		}
		for (var j=0; j<ls.length; j++) {
			lr = ls[j].layoutRows;
			if (lr.constructor != Array) {
				ls[j].layoutRows = [lr];
			}
			for (var k=0; k<ls[j].layoutRows.length; k++) {
				li = ls[j].layoutRows[k].layoutItems;
				if (li.constructor != Array) {
					ls[j].layoutRows[k].layoutItems = [li];
				}
			}
		}
		caseLayout = JSON.stringify(ls);
	}
}
//prepareCaseEditBlock(caseLayout);

$( function() {
	$('#CommentContent').hide();
	$('#CommentHeader').click(function(){
		$('#CommentContent').toggle();
	});
});