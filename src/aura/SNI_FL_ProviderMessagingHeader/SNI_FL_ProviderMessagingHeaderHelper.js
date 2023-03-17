({
	loadDirectMessageList : function(component,event,helper){
        var pageSize = 10;
        var pageNumber = 1;
        var selectedId = component.get("v.selectedId");
        var agentID = $A.get("$SObjectType.CurrentUser.Id");
        var isUnread = component.get("v.isUnread");
        var action = component.get("c.getDirectMessageList");
        var proAffId = component.get("v.providerAffliationID");

        action.setParams({
            "isFamilyLevel":false,
            "agentID":agentID,
            "familiyAccountID":proAffId,
            "pageNumber":pageNumber,
            "pageSize":pageSize,
            "isFlagged":false,
            "isBackupAgent":true,
            "isProviderMsgLevel":false,
            "selectedId": selectedId, // added by Nanthu to track related to selected messages
            "isUnread": isUnread, // added by Nanthu to get FL unread messages
            "isProvider":false
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
                
                var lstOfDirectMessages = response.getReturnValue();
                if(!$A.util.isEmpty(lstOfDirectMessages)){ 
                    
                    //added vamsi 
                    lstOfDirectMessages.forEach(function(record){
                        if(record.directMessageFeed.initiatedUser.profileName== 'Center for Health Navigation' || record.directMessageFeed.initiatedUser.profileName == 'System Administrator'  ){
                            record.directMessageFeed.initiatedUser.userLastName = record.directMessageFeed.initiatedUser.userLastName.substring(0,1);
                        }
                    })
                    
                    component.set("v.lstDirectMessages",lstOfDirectMessages);                                         
                    component.set("v.recordStart",lstOfDirectMessages[0].recordStart);
                    component.set("v.totalRecords",lstOfDirectMessages[0].totalRecords);
                    component.set("v.pageNumber",pageNumber);
                    if(lstOfDirectMessages[0].recordEnd > lstOfDirectMessages[0].totalRecords){
                        component.set("v.recordEnd", lstOfDirectMessages[0].totalRecords);
                    } else {
                        component.set("v.recordEnd", lstOfDirectMessages[0].recordEnd);
                    }
                    component.set("v.totalPages", Math.ceil(lstOfDirectMessages[0].totalRecords / pageSize));
                } else{
                    component.set("v.lstDirectMessages",null);
                }
            }
                
        });
        $A.enqueueAction(action);        
    },
    
    //DE409699 added providerAffliationID attribute
    getAffliationName:function(component,event){
       
        var action = component.get("c.getAffliationName");
        action.setParams({
            "affliationID":component.get("v.providerAffliationID")
        });
        action.setCallback(this,function(response){
            
            if(response.getState()=='SUCCESS'){
               
                component.set("v.AffliationName",response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
    },
    checkHistoricMessages:function(component,event){
        var action = component.get('c.getProviderHistoryEnabled');
        action.setParams({
            "providerAff":component.get('v.providerAffliationID')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                var res = response.getReturnValue();
                component.set("v.histMessageEnabled",res);
                component.set("v.histMessagePrevious",res);
            }
        });
        $A.enqueueAction(action);
    }
})