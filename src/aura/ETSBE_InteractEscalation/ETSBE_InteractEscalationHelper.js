({
    updatecaserec : function(cmp,event,helper) {
        var selectedUser=cmp.find('selRecords').get("v.selectedDataObj");
        var mapLines = {};
        for(var i=0; i<selectedUser.length;i++ ){
            mapLines[i] = selectedUser[i];
        }
        var strwrapperData = '{"WhoOwnsIssue":"' + cmp.get("v.ownsIssue") + '",'
        + '"WhereWasIssueRouted":"' + cmp.get("v.issueRouted") + '",'
        + '"IsSpecRepWorking":"' + cmp.get("v.specRepWorking") + '",'
        + '"RequestNumber":"' + cmp.get("v.reqNum") + '",'
        + '"MemberInfo":"' + cmp.get("v.memInfo") + '"}';
        // + '"EscalationDesc":"' + cmp.get("v.escalationDesc") + 
        
        var action = cmp.get("c.updateCaserec");
        action.setParams({ 
            intractid : cmp.get("v.recordId"),
            strWrapper : strwrapperData ,
            EscalationDesc : cmp.get("v.escalationDesc"),
            selectedUser  : JSON.stringify(mapLines)
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.chcksave", false);
                $A.get("e.force:closeQuickAction").fire();
                console.log('Intreaction record updated successfully.');
            }
        });  
        $A.enqueueAction(action);
    },
    
    checkCaseEsc : function(cmp,event,helper){
        var stat = cmp.find("escurntsts").get("v.value");
        var action = cmp.get("c.checkCaseEsc");
        var chcksave = cmp.get("v.chcksave");
        var self = this;
        console.log('----chcksave--'+chcksave);
        action.setParams({ intractid : cmp.get("v.recordId")});        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var responseData = response.getReturnValue();            
            console.log('resonponse value'+responseData);
            if (state === "SUCCESS") {
                if(responseData != undefined && responseData != null) {
                    var resoval = responseData.isCaseEsc;
                    if(stat != "Closed" && resoval == true && chcksave == true){
                        cmp.set("v.showinfo", true);
                        cmp.set("v.disfields", true);
                        cmp.set("v.disClearbutt", true);
                    }
                    cmp.set("v.ownsIssue", responseData.interactOwner);
                    self.checkResearch(cmp);
                }                
            }
        });  
        $A.enqueueAction(action);
    },
    checkResearch : function(component,event,helper){
        
        var action = component.get("c.getUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            	var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
                var userProfileName = component.get("v.userInfo").Profile_Name__c;
                if (userProfileName == $A.get("$Label.c.ETSBE_ResearchUserProfile")){           
                   component.set("v.isResearchUser", "true");
                   component.set("v.disfields", true); 
                }
            }
        });
        $A.enqueueAction(action);

    }
                   
})