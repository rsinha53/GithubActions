({
    // To prepopulate the seleted value pill if value attribute is filled
    doInit : function( component, event, helper ) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        
        var dropDown = component.find("dropDown");
        $A.util.removeClass(dropDown,'slds-is-open');
        $A.util.addClass(dropDown,'slds-is-close');
        $A.util.removeClass(dropDown,'slds-show');
        $A.util.addClass(dropDown,'slds-hide');

    },
    
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 

        var dropDown = component.find("dropDown");
        $A.util.addClass(dropDown,'slds-show');
        $A.util.removeClass(dropDown,'slds-hide');
       
        $A.util.addClass(dropDown,'slds-is-open');        
        $A.util.addClass(component.find('resultsDiv'),'slds-show');

        var action = component.get("c.getPartnerQueues");
        
        action.setCallback(this, function(result){
            if(result.getState() == 'SUCCESS'){
                component.set("v.listOfSearchRecords", result.getReturnValue());
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
                component.set('v.showDropdown',true);
                var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
                cmpEvent.setParams({
                    showOnclickCurtain : true
                });
        		cmpEvent.fire();
            } else if(result.getState()=='ERROR'){
                var errors = result.getError();
                console.log("Error Message "+errors[0].message);
            }
        });
        $A.enqueueAction(action);
        
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
       
    },

   // When an item is selected
    selectItem : function( component, event, helper ) {
        
        var listOfSearchRecords = component.get('v.listOfSearchRecords');
        var index = listOfSearchRecords.findIndex(x => x.value === event.currentTarget.id)
        if(index != -1) {
            var selectedPartnerQueue = listOfSearchRecords[index];
        }

        component.set('v.selectedPartnerQueue',selectedPartnerQueue);
        component.set('v.value',selectedPartnerQueue.value);

        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : false
        });
        cmpEvent.fire();
    },
    
    onblur : function(component,event,helper) {
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        if(component.get('v.showOnclickCurtain') == false){
            component.set("v.listOfSearchRecords", null );
            var forclose = component.find("resultsDiv");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            component.set('v.showDropdown',false);
        }
    },

    // To remove the selected item.
    removeItem : function( component, event, helper ){
        component.set('v.selectedPartnerQueue','');
    }

    
    
})