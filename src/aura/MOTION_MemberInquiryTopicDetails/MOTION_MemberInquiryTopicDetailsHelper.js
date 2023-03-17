({
    tabOpenDetails: function(cmp, event, helper){
        if (cmp.get("v.pageReference") != null){            
            var tabState = cmp.get("v.pageReference").state;
            cmp.set('v.HighlightsInfocardDetails', JSON.parse(tabState.c__HighlightsInfocardDetails));
            cmp.set('v.fullName', tabState.c__fullName);
            cmp.set('v.interaction', JSON.parse(tabState.c__interaction));
            cmp.set('v.memberId', tabState.c__memberId);
            cmp.set('v.originatorId', tabState.c__originatorId);
            cmp.set('v.orgid', tabState.c__orgid);
            cmp.set('v.originator', tabState.c__originator);
			cmp.set('v.groupNo', tabState.c__groupNo);
            cmp.set('v.groupName', tabState.c__groupName);
            console.log('isMemberNotfound'+tabState.c__isMemberNotFound);
            
            cmp.set('v.isMemberNotFound', tabState.c__isMemberNotFound);
            cmp.set('v.DermID', tabState.c__DermID);                       
           console.log('tabState.c__interaction>>>>>', tabState.c__interaction);
           console.log('v.interaction>>>>>', cmp.get('v.interaction'));
			var autodockey = 'Motion_Inquiry'+cmp.get('v.memberId') +Date.now();
			cmp.set('v.autodocUniqueId',autodockey);
        }
    },
    validationLogicInit: function(component, event, helper){
       var action = component.get("c.setDermInquiryInformations");
        action.setCallback(this,function(response){           
            var state = response.getState();
			
            if(state === "SUCCESS"){     
                var result  = response.getReturnValue();
                component.set('v.DremInquiry',result);
                //component.set('v.defaultValue',defaultValue);               
         }           
        });
        var consoleaction = component.get("c.setConsoleInquiryInformations");
        consoleaction.setCallback(this,function(response){           
            var state = response.getState();
			
            if(state === "SUCCESS"){     
                var result  = response.getReturnValue();
                component.set('v.consoleInquiry',result);             
         }           
        });
        $A.enqueueAction(action); 
        $A.enqueueAction(consoleaction); 
     	 
    },
    validatesave:function(component,event,helper){
        if(component.get('v.validateSelectRow') || component.get('v.validatecomments')){
            component.set('v.validationCondition', true);
        }else{
         	component.set('v.validationCondition', false);   
        }
    }
   
})