({
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component        
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){        
        // show the spinner,show child search result component and call helper function        
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.addClass(forOpen, 'slds-has-focus');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        
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
    keyDownEventController : function(component, event, helper) {
       	if (event.which === 13){      
        	var topicEvent = component.getEvent("oshowTopicEvent");
            // set the Selected sObject Record to the event attribute. 
        	//alert("Inside LI-1" + topicEvent); 
        	//topicEvent.setParams({"topics" : null });  
        	// fire the event
         	topicEvent.fire();
        }
        
    },
    keyPressEventController : function(component, event, helper) {  
        if (event.which === 13){                        
            if (component.get("v.listOfSearchRecords") != null && component.get("v.listOfSearchRecords").length == 1){
                $A.util.removeClass(component.find('lookup-pill'), "slds-has-error");                        
                component.set("v.SearchKeyWord",null);                	 
                var listSelectedItems =  component.get("v.lstSelectedRecords");                
                var selectedAccountGetFromEvent = component.get("v.listOfSearchRecords")[0];  
                listSelectedItems.push(selectedAccountGetFromEvent);
                component.set("v.lstSelectedRecords" , listSelectedItems); 
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
            }
         }
        
    },    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        console.log('on remove of option---'+selectedPillId);
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {

        $A.util.removeClass(component.find('lookup-pill'), "slds-has-error");        
        component.set("v.SearchKeyWord",null); 
        
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        var valueSelected = event.getParam("isSelectValue");
        
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');    
    },
    
    focusRecord : function(component, event, helper){
        var focusedRec = component.get("v.oRecord.Name");   
        focusedRec.focus();
    },
    keyDown : function(component, event, helper){
    },
    KeyPresss : function(component, event, helper) {                
    }   
})