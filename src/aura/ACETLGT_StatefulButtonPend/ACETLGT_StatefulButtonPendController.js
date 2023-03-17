({
	handleClick: function(cmp, event, helper) {

        cmp.set('v.changedRow', cmp.get('v.componentname'));
        cmp.set('v.stateful', (!cmp.get('v.stateful')));
    }
        
})