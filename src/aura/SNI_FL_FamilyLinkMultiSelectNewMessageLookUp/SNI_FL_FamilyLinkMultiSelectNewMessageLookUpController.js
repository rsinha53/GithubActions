({
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", []); 
        
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    onblur : function(component,event,helper) {
        // on mouse leave clear the listOfSeachRecords & hide the search result component
        component.set('v.listOfSearchRecords', []);
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    // perform search on change of text in search box
    keyPressController : function(component, event, helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var getInputkeyWord = component.get('v.SearchKeyWord');
        helper.searchHelper(component,event,getInputkeyWord);
    },

    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords");
        var removedItems =  component.get("v.removedSelectedRecords");

        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].value == selectedPillId){
                removedItems.push(AllPillsList[i]);
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }
        }

        component.set("v.SearchKeyWord","");
        component.set("v.listOfSearchRecords", []);
        component.set("v.removedSelectedRecords", removedItems);
        
    },

    
    handleClear:function(component,event,heplper){
        component.set("v.SearchKeyWord","");
        component.set("v.listOfSearchRecords", []);
        component.set("v.removedSelectedRecords", []);

        if(!component.get("v.isBackupAgentView")){
            let arr= component.get("v.lstSelectedRecords");
            arr.splice(1,arr.length);
            component.set("v.lstSelectedRecords",arr);
        }else{
            component.set("v.lstSelectedRecords",[]);
        }
        
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord","");
        // get the selected object record from the COMPONENT event 	
        
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");

        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" ,listSelectedItems );
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    }
    
})