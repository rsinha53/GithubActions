({
    doInit : function(component, event, helper ){
        
        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        var isFamilyLevelcondition = component.get("v.isFamilyLevel");
        var isFamilyLinkcondition = component.get("v.isFamilyLink");
        if(!isBackupAgentViewcondition && !isFamilyLevelcondition && !isFamilyLinkcondition){
            helper.loadFamilyOwner(component, event, helper);
        }
        helper.getToolTip(component,event,helper);
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
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    onblur : function(component,event,helper){
        if(component.get('v.showOnclickCurtain') == false){
            // on mouse leave clear the listOfSeachRecords & hide the search result component
            component.set("v.listOfSearchRecords", null );
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            //component.set('v.SearchKeyWord','');
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
        if(getInputkeyWord.length >0){
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

        var isBackupAgentViewcondition = component.get("v.isBackupAgentView");
        var isFamilyLevelcondition = component.get("v.isFamilyLevel");
        var isFamilyLinkcondition = component.get("v.isFamilyLink");
        if(!isBackupAgentViewcondition && !isFamilyLevelcondition && !isFamilyLinkcondition){
       
            for(var i = 0; i < AllPillsList.length; i++){
                if(AllPillsList[i].Id == selectedPillId){
                    if(i == 0){
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
        } else {
            for(var i = 0; i < AllPillsList.length; i++){
            
                if(AllPillsList[i].Id == selectedPillId){
                    removedItems.push(AllPillsList[i]);
                    AllPillsList.splice(i, 1);
                    component.set("v.lstSelectedRecords", AllPillsList);
                }  
            }
        }
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
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
        component.set("v.lstSelectedRecords",[]);
        component.set("v.removedSelectedRecords", []);
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
        //listSelectedItems.push(selectedAccountGetFromEvent);
        //component.set("v.lstSelectedRecords" , listSelectedItems);
        
        var flag =  component.get("v.isFL");
        var flg =  component.get("v.isFlg");
        if(!flag){
            if(listSelectedItems.length<10){
                listSelectedItems.push(selectedAccountGetFromEvent);
                component.set("v.lstSelectedRecords" , listSelectedItems); 
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    'title':'Error!',
                    'message' : 'you can restrict '
                });
                toastEvent.fire();
            }
        }else{
            if(flag && !flg){
                listSelectedItems.push(selectedAccountGetFromEvent);
                component.set("v.lstSelectedRecords" , listSelectedItems[listSelectedItems.length-1]);
            }else if(flag && flg){
                if(listSelectedItems.length<4){
                    listSelectedItems.push(selectedAccountGetFromEvent);
                    component.set("v.lstSelectedRecords" ,listSelectedItems );
                   // component.set("v.lstSelectedRecords" ,Object.fromEntries(listSelectedItems));
                }
            }
        }
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        /* var cmpEvent = component.getEvent("cmpEvent");
        cmpEvent.setParams({
            "listOfSearchRecordsEvt" : component.get("v.lstSelectedRecords") });
        cmpEvent.fire();*/
    },
})