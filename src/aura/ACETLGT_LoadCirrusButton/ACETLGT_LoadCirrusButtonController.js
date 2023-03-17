({
	loadCirrusPage : function(component, event, helper) {   
                
                var memId = component.get("v.memberId");
                var groupId = component.get("v.gorupId");
                var subType = component.get("v.subjectType");
                var topicName = component.get("v.topicName");
                var landPageInCirrus = component.get("v.landingPageinCirrus");
                
                console.log(' Parameters ::: '+memId+' :: '+groupId+' :: '+subType+' :: '+topicName+ ' :: '+landPageInCirrus );
                
                //var action = component.get("c.GenerateCIRRUSURL");
                var action = component.get("c.GenerateCIRRUS");
                action.setParams({
                        "MemberId": memId,
                        "landingPage": landPageInCirrus,
                        "subjectType": subType,
                        "topic": topicName,
                        "groupId": groupId
                
                });
                action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                                var storeResponse = response.getReturnValue();                
                                component.set("v.cirrusURL", storeResponse); 
                                helper.getCIRRUSURL(component, event, helper);               
                        }
                });
                $A.enqueueAction(action);
                
                //var cirrusurl = "https://acet-uhg--qa201--c.cs26.visual.force.com/idp/login?app=0sp210000004CDP&RelayState=https%3A%2F%2Fcirrus-alpha.optum.com%2Fpingfederatesso.uhg%3FlandingPage%3DmemberDetail%26externalIDType%3DSC%26encryptedData%3DB6J1ebfIz4tJ38xtcaJXnjg1aV0X9z0AbTxwEEv1HgJvNEpIfd6oGP6nz%252BqEFHKqTLw4tMnx5Ebu1eYPCCQ1WQ%253D%253D";
                
                
                
                      
       
		
	}
})