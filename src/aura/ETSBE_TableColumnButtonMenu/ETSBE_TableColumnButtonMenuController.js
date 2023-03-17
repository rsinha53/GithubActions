({
    
    handleSelect: function(cmp, event) {
        var selectedMenuItemValue = event.getParam("value");
        var menuItems = cmp.find('menuItems');
        var menuItem = menuItems.find(function(menuItem) {
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                menuItem.set("v.checked", true);
                cmp.set('v.selectedColumn', cmp.get("v.columnMenuID"));
                cmp.set('v.selectedOption', menuItem.get("v.value"));
            } else {
                menuItem.set("v.checked", false);
            }
        });
    }
    
})