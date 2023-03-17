({
    init: function(component, event, helper){
        var url = window.location.search;
        url = url.replace("?", '');
        var parsed = url.split('&');
        var personId = '';
        var isProvider = false;
        var isMemberAff = false;
        for(var i = 0; i < parsed.length; i++){
            if(parsed[i].includes('personID')){
                var persId = parsed[i].split('=');
                personId = persId[1];
                component.set('v.personID', personId);
            } else if(parsed[i].includes('isProvider')){
                var isProv = parsed[i].split('=');
                isProvider = isProv[1];
            } else if(parsed[i].includes('isMemAff')){
                var isMemAff = parsed[i].split('=');
                isMemberAff = isMemAff[1];
            }
        }
        component.set('v.isProvider', isProvider);
        component.set('v.isMemAff', isMemAff);
        if(isProvider == false){
            var action=component.get("c.getsingleMsg");
            action.setParams({
                "requestType":"person",
                "Id": personId
            });
            action.setCallback(this,function(response){
                if(response.getState()=="SUCCESS"){
                    var result = response.getReturnValue();
                    if(result.length != 0){
                        if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                            component.set('v.personHistMsgs', result.singleMsgList );
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
        } else if(isProvider == 'true'){
            if(isMemberAff == 'true'){
            var action=component.get("c.getsingleMsg");
            action.setParams({
                "requestType":"memberAffiliation",
                "Id": personId
            });
            action.setCallback(this,function(response){
                if(response.getState()=="SUCCESS"){
                    var result = response.getReturnValue();
                    if(result.length != 0){
                        if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                            component.set('v.personHistMsgs', result.singleMsgList );
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
            } else{
                var action=component.get("c.getProviderMessages");
                action.setParams({
                    "Id": personId,
                    "pageNumber": 1
                });
                action.setCallback(this,function(response){
                    if(response.getState()=="SUCCESS"){
                        var result = response.getReturnValue();
                        if(result.length != 0){
                            if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                                component.set('v.providerHeaderList', result.providerMessages);
                                component.set('v.providerHasNext', result.hasNext);
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
        }
    },
    myAction : function(component, event, helper) {
          event.preventDefault();
           var goBack = window.open('', 'parent');
           goBack.focus(); 
          window.close();	
    },
    getMemberAffFromEvent : function(component,event,helper){
        var memAff = event.getParam("memberAffiliationId");
        var authName = event.getParam("ListauthorName");
        var listDateTime = event.getParam("ListDateTime");
        component.set('v.personHistMsgs', []);
        if(memAff != undefined && memAff != null && memAff != ''){
            var action=component.get("c.getsingleMsg");
            action.setParams({
                "requestType":"memberAffiliation",
                "Id": memAff
            });
            action.setCallback(this,function(response){
                if(response.getState()=="SUCCESS"){
                    var result = response.getReturnValue();
                    if(result.length != 0){
                        if(result.statusCode == 200 && (result.statusMessage == undefined || result.statusMessage == null || result.statusMessage == '')){
                            component.set('v.personHistMsgs', result.singleMsgList );
                            component.set('v.listname', authName );
                            component.set('v.listdatetime', listDateTime );
                            component.set('v.showMobileMessage', true);
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
    handleSpinner : function(component,event,helper){
        var isShowSpinner = event.getParam("showSpinner");
        var spinner = component.find("dropdown-spinner");
        if(isShowSpinner){
            $A.util.removeClass(spinner, "slds-hide");
            $A.util.addClass(spinner, "slds-show");
        } else {
            $A.util.removeClass(spinner, "slds-show");
        	$A.util.addClass(spinner, "slds-hide");
        }
    },
    scrollIntoView : function(component,event,helper){
        var authName = event.getParam("ListauthorName")
        component.set('v.scrollToAuthName', authName);
    },
})