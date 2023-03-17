({
	search: function (cmp, event) {
        var data = cmp.get("v.tableBody");

       // const inputValue = event.getSource().get('v.value').toUpperCase();
        var filtered = [];
        
        data.forEach(filterRecs);
        
        function filterRecs(item, index) {
            if(index < 25){        
                filtered.push(item);
            }
        }
        console.log('In TableWith Header Heleper:search: filtered::'+ filtered.length);
        //console.log('In TableWith Header Heleper:search: filtered::'+ JSON.stringify(filtered));
        cmp.set("v.tableBody", filtered);
    },
})