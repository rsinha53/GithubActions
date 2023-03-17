({
    getData : function(cmp,event,helper) {
        var caseId = cmp.get("v.recordId");
        console.log('entered casecomments getData, caseId - '+ caseId);        
        var action = cmp.get('c.getCaseComments');
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/lightning/r/User/'+record.CreatedBy.Id+'/view';
                    record.createByName = record.CreatedBy.Name;
                    if(record.linkName){
                        record.linkIcon ='standard:avatar_loading';
                      	record.CommentBodyclass = 'slds-cell-wrap';
                        //record.customCssClass='slds-avatar slds-avatar_profile-image-small ';
                        // record.linkIcon= 'slds-avatar slds-avatar_profile-image-large';
                    }
                });
                cmp.set("v.commentsdata", records);
               
                
            }
        });
        $A.enqueueAction(action);
    },
    
})