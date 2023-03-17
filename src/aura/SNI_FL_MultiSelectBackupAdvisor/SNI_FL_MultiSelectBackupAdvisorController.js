({
     doInit : function(component,event,helper){
         // call the apex class method 

        var action = component.get("c.getProfileName");   
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                component.set("v.ProfileName",response.getReturnValue()); 
                console.log("ProfileName: " + component.get('v.ProfileName'));
            }
            else {
                console.log("Failed with state: " + state);
            }   
        });
        $A.enqueueAction(action);

    },
    
    onblur : function(component,event,helper){
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
       
   /* closePanel: function(component,event,helper){
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },*/
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');

        //var getInputkeyWord = '';
        var searchKey = component.get("v.SearchKeyWord"); 
 		var getInputkeyWord;
        if(searchKey === undefined || searchKey === null )
        {
            getInputkeyWord = '';
        }
        else
        {
            getInputkeyWord = searchKey;
        }
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
        }
    },
    
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        var TOremoveList =[];
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        //Set event attribute value
        cmpEvent.setParams({"message" : selectedPillId}); 
        cmpEvent.fire(); 
        
    },
    
    
    
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var listSelectedItem;
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var flag = component.get("v.isFL");
        if(!flag){
            if(listSelectedItems.length<10){
                listSelectedItems.push(selectedAccountGetFromEvent);
                component.set("v.lstSelectedRecords" , listSelectedItems);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "You can add maximum of 10 backup advisors."
                });
                toastEvent.fire();
            }
        
        }
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
})