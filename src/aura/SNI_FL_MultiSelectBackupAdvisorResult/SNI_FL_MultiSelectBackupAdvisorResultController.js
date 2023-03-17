({
    doInit : function(component, event, helper){
        
        var selectedRecordList = component.get("v.selectedListRecords");
        var getSelectRecord = component.get("v.oRecord");
        if(!$A.util.isEmpty(getSelectRecord)){
            if(typeof getSelectRecord.LastName !== 'undefined' && getSelectRecord.LastName != null){
                if(typeof getSelectRecord.UserRole !== 'undefined' && getSelectRecord.UserRole != null) {
                  if(getSelectRecord.UserRole.Name.includes('FEC') || getSelectRecord.UserRole.Name.includes('Registered Nurse')) {
                     console.log('user role fec nurse');
                     component.set('v.isToolTip',true);
                  }
               }
            }else if(typeof getSelectRecord.Partner__c !== 'undefined') {
                      console.log('partner records');
                      component.set('v.isToolTip',true);
           }else if(typeof getSelectRecord.SNI_FL_Member__c !== 'undefined') {
                    console.log('care team members');
                    component.set('v.isToolTip',false);
            }
        } 
         for(var i = 0; i<selectedRecordList.length; i++) {
          if(!$A.util.isEmpty(getSelectRecord)){   
            if(selectedRecordList[i].Name == getSelectRecord.Name){
                component.set("v.disabled", true);
                break;
            }            
        }
         } 
    },
    
    selectRecord : function(component, event, helper) {
        var getSelectRecord = component.get("v.oRecord");
        console.log("getSelectRecord in dropdown : ",getSelectRecord);
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : getSelectRecord});
        compEvent.fire();
        component.set("v.disabled", !component.get("v.disabled"));
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        var cmpEvent = component.getEvent("SNI_FL_MessageOnclickCurtainEvent");
        cmpEvent.setParams({
            showOnclickCurtain : false
        });
        cmpEvent.fire();
    },
    
    
})