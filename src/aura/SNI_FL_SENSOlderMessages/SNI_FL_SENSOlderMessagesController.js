({
    doInit : function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        if(!(myPageRef===null) && !(myPageRef.state===null)){
            var familyId = myPageRef.state.c__familyId;
            component.set("v.familyId", familyId);
            var AccountName = myPageRef.state.c__AccountName;
            var resqType = myPageRef.state.c__RequestType;
            if(resqType == "memberAffiliation"){
                component.set("v.TabName","- Older Messages");
            }
            component.set("v.AccountName", AccountName);
            var action=component.get("c.getsingleMsg");
            action.setParams({
                "requestType": resqType,
                "Id":familyId
            });
            action.setCallback(this,function(response){
                if(response.getState()=="SUCCESS"){
                    var result = response.getReturnValue();
                    if(result.length != 0){
                        if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                        component.set('v.singleMsgList', result.singleMsgList );	
                        component.set('v.listname', result.ListauthorName );
                		component.set('v.listdatetime', result.ListDateTime );
                        } else {
                            helper.fireToast(result.statusMessage, result.statusCode);
                        }
                    } else{
                        helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
                    }
                } else {
                    helper.fireToast('There has been an error retrieving your older messages. We are working to resolve the problem now. Please try again later.',500);
                }
            });
            $A.enqueueAction(action);
        }
    },
})