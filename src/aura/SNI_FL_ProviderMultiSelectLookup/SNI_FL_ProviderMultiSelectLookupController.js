({
    doInit : function(component, event, helper ){
        var selectedTabId = component.get('v.selectedTabId');
    },

    userChange: function(component, event, helper ){
        var selectedBackUp = component.get('v.userRecord');
        var Advisor = [];
        Advisor.push({"label":selectedBackUp.Name+'(Advisor)',"userType":"A","value":selectedBackUp.Id});
        var selectedItems = component.get('v.lstSelectedRecords');
        component.set('v.lstSelectedRecords',Advisor);

        
    },

    onfocus : function(component,event,helper){
        
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        if(component.get("v.selectProviderAfliation")){
            
            helper.searchHelper(component,event,getInputkeyWord);
              
        }
        
    },
    
    onblur : function(component,event,helper) {
        if(component.get('v.showOnclickCurtain') == false){
            // on mouse leave clear the listOfSeachRecords & hide the search result component
            component.set("v.listOfSearchRecords", null );
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            component.set('v.showDropdown',false);
        }
    },
    
    
    keyPressController : function(component, event, helper) { 
       
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length >2){
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
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords");
        var removedItems =  component.get("v.removedSelectedRecords");

        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].value == selectedPillId){
                if(i == 0 && !component.get("v.isBackupAgentView")){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "You are not allowed to remove this recipient."
                    });
                    toastEvent.fire();
                    break;
                }   
                removedItems.push(AllPillsList[i]);
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }
            
        }
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : false
        });
        cmpEvent.fire();
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.removedSelectedRecords", removedItems);
        
    },
    
    //added Vamsi
    handleClear:function(component,event,heplper){
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", [] );
        component.set("v.removedSelectedRecords", []);

        if(!component.get("v.isBackupAgentView")){
            let arr= component.get("v.lstSelectedRecords");
            arr.splice(1,arr.length);
            component.set("v.lstSelectedRecords",arr);
        }else{
            component.set("v.lstSelectedRecords",[]);
        }
        
    },
    
    handleDefaultUser:function(component, event, helper ){
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        var isFamilyLevelcondition = component.get("v.isFamilyLevel");
        var isFamilyLinkcondition = component.get("v.isFamilyLink");
        if(!isBackupAgentViewcondition && !isFamilyLevelcondition && !isFamilyLinkcondition){
            helper.loadFamilyOwner(component, event, helper);
        }
    },

    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        // get the selected object record from the COMPONENT event 	
        
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
       
        
        let isBackupAgentView =component.get("v.isBackupAgentView");
        let isPersonAccountView =component.get("v.familyId")?true:false;
        let isAgentView = (isBackupAgentView && !isPersonAccountView)?true:false;

        
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" ,listSelectedItems );
 
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

        
    },
})