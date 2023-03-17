({
    initializeMemberCardCount: function (cmp){
        var items = [];
        for (var i = 1; i < 21; i++) {
            var item = {
                "label": i,
                "value": i.toString(),
            };
            items.push(item);
        }
        cmp.set("v.numbers", items);
        //cmp.set("v.optionValue", 1);
        
    },
    initializeMemberCard : function (component, event, helper) {
        var numberOfMemSections = component.find('numbersIdButton').get('v.value');
        var appEvent = $A.get("e.c:ACET_AddMembersToSearchEvent");
        appEvent.setParams({
            "numbers" : numberOfMemSections
        });
		appEvent.fire();
    },
    resetMembers: function (cmp, event, helper) {
        //cmp.set("v.optionValue", 1);
        var appEvent = $A.get("e.c:ACET_resetAddMembersToSearchEvent");
		appEvent.fire();
    },

})