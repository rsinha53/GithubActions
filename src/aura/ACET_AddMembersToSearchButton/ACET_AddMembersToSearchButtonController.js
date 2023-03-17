({
    doInit : function(cmp, event, helper) { 
        helper.initializeMemberCardCount(cmp);       
    },
    
    openMembersSelection: function (cmp, event, helper) {
        if(!cmp.get('v.showMembersSelction')){
            cmp.set('v.showMembersSelction', true);
            cmp.find("numbersIdButton").set("v.value", "1");
        }
        $A.util.removeClass(cmp.find("hideNumberSelctions"), "slds-hide");
    },
    
    resetMembersCard: function(cmp, event, helper){
        cmp.set('v.showMembersSelction', false);
        helper.resetMembers(cmp, event, helper);
    },
    
    showMembers: function (cmp, event, helper) {
        helper.initializeMemberCard(cmp);  
    },
    numberOnchangehandler: function (cmp, event, helper) {
        var optionvalue = cmp.find("numbersIdButton").get("v.value");
        console.log("optionvalue: "+optionvalue);
        cmp.set("v.optionValue",optionvalue);
    }
    
})